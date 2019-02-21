output "SQS URL" {
  value = "${aws_sqs_queue.queue.id}"
}

output "Table name" {
  value = "${aws_dynamodb_table.table.name}"
}

output "Website URL" {
  value = "${aws_s3_bucket.bucket.website_endpoint}"
}
