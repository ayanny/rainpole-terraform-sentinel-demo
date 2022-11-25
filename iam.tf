#Creates iam role for ssm
resource "aws_iam_role" "awsssm" {
  name = "awsssm"
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

#Create iam profile for ssm
resource "aws_iam_instance_profile" "awsssm" {
  name = "${aws_iam_role.awsssm.name}-profile"
  role = aws_iam_role.awsssm.name
}