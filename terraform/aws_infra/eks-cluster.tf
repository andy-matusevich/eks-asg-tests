provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

variable "eks_instance_type_monitoring" {
  default = "t2.micro"
}

variable "eks_instance_type_applications" {
  default = "t2.micro"
}

locals {
  k8s_tag = "kubernetes.io/cluster/${var.cluster_name}"
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets

  tags = {
    repo        = var.cluster_name
    environment = var.environment
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "monitoring-group"
      instance_type                 = var.eks_instance_type_monitoring
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      kubelet_extra_args            = "--node-labels=node.kubernetes.io/assignment=monitoring"
    },
    {
      name                          = "applications-group"
      instance_type                 = var.eks_instance_type_applications
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      kubelet_extra_args            = "--node-labels=node.kubernetes.io/assignment=applications"
    },
  ]

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
