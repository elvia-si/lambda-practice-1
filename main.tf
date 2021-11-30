provider "aws" {
  region = "eu-west-1"
}

#Create new bucket
resource "aws_s3_bucket" "my_lambda_bucket" {
  bucket = "ta-954444250632-lambda-lab"
  
  versioning {
      enabled = true
  }

  tags = {
    Name        = "ta-lambda-lav"
    Environment = "Test"
  }
}

#upload file to s3 bucket
resource "aws_s3_bucket_object" "sample_data" {

  bucket = aws_s3_bucket.my_lambda_bucket.id

  key    = "data-to-test-lambda"

  source = "./sample_data.json"

  etag = filemd5("./sample_data.json")

}

#Lambda function with assume role
resource "aws_iam_role" "iam_for_lambda_practice1" {
  name = "lambda-practice1"

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

resource "aws_iam_policy" "lambda_practice1_policy" {
    name = "lambda-practice1-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
        "Sid": "ListObjectsInBucket",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::ta-954444250632-lambda-lab"]
    },
    {
        "Sid": "AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": ["arn:aws:s3:::ta-954444250632-lambda-lab/*"]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda_practice1.name
  policy_arn = aws_iam_policy.lambda_practice1_policy.arn
}

