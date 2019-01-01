resource "aws_iam_instance_profile" "profile" {
  name = "SwarmDiscoveryBucketAccess"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "SwarmDiscoveryBucketRole"
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

resource "aws_iam_role_policy" "policy" {
  name = "SwarmDiscoveryBucketPolicy"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListObjects"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}",
      "Action": [
        "s3:ListBucket"
      ]
    }
  ]
}
EOF
}
