resource "aws_iam_instance_profile" "profile" {
  name = "JenkinsSlavesAccess"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "JenkinsSlavesRole"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "UploadStaticFiles"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::movies-database-demo/*",
      "Action": [
        "s3:PutObject"
      ]
    }
  ]
}
EOF
}
