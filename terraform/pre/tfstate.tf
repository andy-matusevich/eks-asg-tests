provider "aws" {
    region = var.tfstate_region
}

variable "tfstate_region" {}
variable "tfstate_bucket" {}
variable "tfstate_lock_table" {}

resource "aws_s3_bucket" "tfstate-storage-s3" {
    bucket = var.tfstate_bucket

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = true
    }

}

resource "aws_dynamodb_table" "tfstate-locks" {
  name         = var.tfstate_lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}