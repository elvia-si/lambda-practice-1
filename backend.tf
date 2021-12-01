terraform {
  backend "s3" {
    bucket         = "talent-academy-954444250632-tfstates"
    key            = "sprint2/week2/lambda-training/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}