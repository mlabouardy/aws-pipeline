output "VPC ID" {
  value = "${aws_vpc.default.id}"
}

output "Public Subnets" {
  value = "${aws_subnet.public_subnets.*.id}"
}

output "Private Subnets" {
  value = "${aws_subnet.private_subnets.*.id}"
}

output "Bastion DNS" {
  value = "${aws_route53_record.bastion.name}"
}
