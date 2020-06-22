# https://www.terraform.io/docs/providers/helm/index.html
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

module "eks" {
  #source       = "../aws_infra/.terraform/modules/eks"
  source = "terraform-aws-modules/eks/aws"
  subnets = data.aws_eks_cluster.cluster.vpc_config.subnet_ids
  cluster_name = var.cluster_name
  vpc_id = var.vpc_id
}

variable "cluster_name" {}
variable "environment" {}
variable "region" {}
variable "vpc_id" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_vpc" "selected" {
  id = data.aws_eks_cluster.cluster.vpc_config.vpc_id
}


### nginx-ingress
# https://www.terraform.io/docs/providers/helm/r/release.html
resource "helm_release" "nginx-ingress" {
  name             = "nginx"
  chart            = "nginx-ingress"
  repository       = "https://helm.nginx.com/stable"
  namespace        = "ingress"
  replace          = "true"
  create_namespace = "true"
  atomic           = "true"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }

  set {
    type  = "string"
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = "60"
  }

  set {
    type  = "string"
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
  }

  # /nginx-health
  set {
    type  = "string"
    name  = "controller.healthStatus"
    value = "true"
  }


}
