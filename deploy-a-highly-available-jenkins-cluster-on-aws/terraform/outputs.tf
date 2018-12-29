output "Jenkins DNS" {
  value = "https://${aws_route53_record.jenkins_master.name}"
}

output "Jenkins SG ID" {
  value = "${aws_security_group.jenkins_master_sg.id}"
}
