terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.1.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  # Configuration options
}