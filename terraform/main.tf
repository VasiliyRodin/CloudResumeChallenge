#Providers are meant to connect to the cloud offering of choice. I will be using aws.

terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 5.92"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
    region = "${var.us-east-1}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_access_secret}"
}