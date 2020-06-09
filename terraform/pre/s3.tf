resource "aws_s3_bucket" "state-file-bucket" {
  bucket = "eks-asg-tests"

  versioning {
    enabled = true
  }

  tags = {}
}