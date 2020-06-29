resource "aws_ecr_repository" "ecr" {
  name                 = var.cluster_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = "false"
  }

}

data "aws_ecr_repository" "ecr" {
  name = var.cluster_name
}

data "aws_ecr_authorization_token" "token" {
  registry_id = data.aws_ecr_repository.ecr.registry_id
}
