output "cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}

output "vpc_id" {
  value = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

output "subnet_ids" {
  value = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
}

output "ingress-nginx-controller" {
  value = helm_release.ingress-nginx-controller
}

output "prometheus_status" {
  value = helm_release.prometheus_release.status
}

output "grafana_status" {
  value = helm_release.grafana_release.status
}

locals {
  lb_dns = data.aws_lb.ingress-nginx-controller.dns_name
}

output "grafana_url" {
  value = "http://${local.lb_dns}/grafana"
}
