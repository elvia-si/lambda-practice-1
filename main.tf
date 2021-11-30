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

#Lambda assume role
resource "aws_iam_role" "iam_for_lambda_practice1" {
  name = "lambda-practice1"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#IAM read and write policies and cloudwatch logger
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

#Attach IAM Role and policies
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda_practice1.name
  policy_arn = aws_iam_policy.lambda_practice1_policy.arn
}

#S3 permission to trigger Lambda 
resource "aws_lambda_permission" "allow_bucket_trigger" {
   statement_id = "AllowExecutionFromS3Bucket"
   action = "lambda:InvokeFunction"
   function_name = aws_lambda_function.s3_read_function.function_name
   principal = "s3.amazonaws.com"
   source_arn = "arn:aws:s3:::ta-954444250632-lambda-lab"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_read_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:eu-west-1:111122223333:rule/RunDaily"
  # qualifier     = aws_lambda_alias.test_alias.name
}

#Data source to zip lambda
data "archive_file" "my_lambda_read_function" {
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda.zip"
  type        = "zip"
}

#Lambda function
resource "aws_lambda_function" "s3_read_function" {
   filename = "lambda.zip"
   source_code_hash = data.archive_file.my_lambda_read_function.output_base64sha256
   function_name = "s3_read_function"
   role = aws_iam_role.iam_for_lambda_practice1.arn
   handler = "index.handler"
   runtime = "python3.8"

#    environment {
#        variables = {
#            DST_BUCKET = "${var.env_name}-dst-bucket",
#            REGION = "${var.aws_region}"
#        }
#    }
}




