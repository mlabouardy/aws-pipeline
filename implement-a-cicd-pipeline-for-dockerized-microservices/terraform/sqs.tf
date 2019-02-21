resource "aws_sqs_queue" "queue" {
  name = "${var.queue}"

  tags = {
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}
