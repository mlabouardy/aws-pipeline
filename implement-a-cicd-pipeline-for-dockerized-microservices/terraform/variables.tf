//Global variables
variable "region" {
  description = "AWS region"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
}

variable "aws_profile" {
  description = "AWS profile"
}

// Default variables

variable "bucket" {
  description = "S3 bucket name"
  default     = "movies-database-demo"
}

variable "table" {
  description = "DynamoDB table name"
  default     = "movies"
}

variable "queue" {
  description = "SQS name"
  default     = "movies"
}
