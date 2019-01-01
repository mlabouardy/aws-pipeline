data "aws_ami" "docker" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["docker-18.06.1-ce"]
  }
}
