provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

variable "eks_instance_type_monitoring" {
  default = "t2.small"
}

variable "eks_instance_type_applications" {
  default = "t2.small"
}

locals {
  k8s_tag = "kubernetes.io/cluster/${var.cluster_name}"
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  #subnets         = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = {
    repo        = var.cluster_name
    environment = var.environment
  }

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    extend_config = {
      # This is supplied to the AWS EKS Optimized AMI
      # bootstrap script https://github.com/awslabs/amazon-eks-ami/blob/master/files/bootstrap.sh
      bootstrap_extra_args = "--container-runtime containerd --kubelet-extra-args '--max-pods=20'"

      # This user data will be injected prior to the user data provided by the
      # AWS EKS Managed Node Group service (contains the actually bootstrap configuration)
      pre_bootstrap_user_data = <<-EOT
        export CONTAINER_RUNTIME="containerd"
        export USE_MAX_PODS=false
      EOT
    }
  }

}

#module "eks_managed_node_group_1" {
#  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#
#  name            = "${var.cluster_name}-ng-1"
#  cluster_name    = var.cluster_name
#  cluster_version = "1.21"
#
#  vpc_id = module.vpc.vpc_id
#  subnet_ids = module.vpc.private_subnets
#
#  min_size     = 1
#  max_size     = 3
#  desired_size = 1
#
#  instance_types = ["t2.small"]
#
#  tags = {
#    repo        = var.cluster_name
#    environment = var.environment
#  }
#}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
