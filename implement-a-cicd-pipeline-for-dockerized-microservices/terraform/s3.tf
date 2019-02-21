resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "policy",
  "Statement": [
    {
        "Sid": "Stmt1550759011210",
        "Action": [
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.bucket}/*",
        "Principal": "*"
      }
  ]
}
POLICY
}
