provider "aws" {
  region = var.state_region
}

variable "state_region" {}
variable "state_bucket" {}
variable "state_lock_table" {}

resource "aws_s3_bucket" "tfstate-storage-s3" {
  bucket = var.state_bucket

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_dynamodb_table" "tfstate-locks" {
  name         = var.state_lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}