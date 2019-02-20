package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/aws/aws-sdk-go-v2/aws/external"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/rs/xid"
)

var (
	sqsClient    *sqs.SQS
	dynamoClient *dynamodb.DynamoDB
)

type Movie struct {
	ID          string  ` json:"id"`
	Title       string  `json:"title"`
	Cover       string  `json:"cover"`
	Description string  `json:"description"`
	UserScore   float64 `json:"userscore"`
}

func crawlPage(url string) (string, error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return "", err
	}

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	data, err := ioutil.ReadAll(resp.Body)
	return string(data), err
}

func parseHTML(content string) (Movie, error) {
	doc, err := goquery.NewDocumentFromReader(strings.NewReader(content))
	if err != nil {
		return Movie{}, err
	}

	title := doc.Find(".title span a").Text()
	percent, _ := doc.Find(".user_score_chart").Attr("data-percent")
	userScore, _ := strconv.ParseFloat(percent, 64)
	description := doc.Find(".overview p").Text()
	img, _ := doc.Find("div.poster div.image_content img").Attr("srcset")
	cover := strings.Split(img, " 1x")[0]

	return Movie{
		Title:       title,
		Cover:       cover,
		Description: description,
		UserScore:   userScore,
	}, nil
}

func getMessages() ([]sqs.Message, error) {
	req := sqsClient.ReceiveMessageRequest(&sqs.ReceiveMessageInput{
		QueueUrl: aws.String(os.Getenv("QUEUE_URL")),
	})
	resp, err := req.Send()
	return resp.Messages, err
}

func deleteMessage(receiptHandle *string) error {
	req := sqsClient.DeleteMessageRequest(&sqs.DeleteMessageInput{
		QueueUrl:      aws.String(os.Getenv("QUEUE_URL")),
		ReceiptHandle: receiptHandle,
	})
	_, err := req.Send()
	return err
}

func insertMovie(movie Movie) error {
	req := dynamoClient.PutItemRequest(&dynamodb.PutItemInput{
		TableName: aws.String(os.Getenv("TABLE_NAME")),
		Item: map[string]dynamodb.AttributeValue{
			"id": dynamodb.AttributeValue{
				S: aws.String(xid.New().String()),
			},
			"title": dynamodb.AttributeValue{
				S: aws.String(movie.Title),
			},
			"cover": dynamodb.AttributeValue{
				S: aws.String(movie.Cover),
			},
			"description": dynamodb.AttributeValue{
				S: aws.String(movie.Description),
			},
			"userscore": dynamodb.AttributeValue{
				N: aws.String(fmt.Sprintf("%v", movie.UserScore)),
			},
		},
	})
	_, err := req.Send()
	return err
}

func init() {
	cfg, err := external.LoadDefaultAWSConfig()
	if err != nil {
		log.Fatal(err)
	}

	sqsClient = sqs.New(cfg)
	dynamoClient = dynamodb.New(cfg)
}

func main() {
	for {
		messages, err := getMessages()
		if err != nil {
			log.Fatal(err)
		}

		if len(messages) > 0 {
			log.Println("Crawling:", *messages[0].Body)

			html, err := crawlPage(*messages[0].Body)
			if err != nil {
				log.Fatal(err)
			}
			movie, err := parseHTML(html)

			log.Println("Movie:", movie)

			err = insertMovie(movie)
			if err != nil {
				log.Fatal(err)
			}

			err = deleteMessage(messages[0].ReceiptHandle)
			if err != nil {
				log.Fatal(err)
			}
		} else {
			log.Println("Empty queue")
		}

		time.Sleep(5 * time.Second)
	}
}
