terraform {
  backend "s3" {
    bucket = "tf-backend-devops"
    key    = "terrform-backend/terraform.tfstate"
    region = "us-east-2"
  }
}
