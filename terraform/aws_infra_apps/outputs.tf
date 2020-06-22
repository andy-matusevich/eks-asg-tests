output "cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}

output "vpc_id" {
  value = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

output "subnet_ids" {
  value = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
}

output "nginx-ingress" {
  value = helm_release.nginx-ingress
}

output "prometheus" {
  value = helm_release.prometheus
}

output "grafana" {
  value = helm_release.grafana
}

output "password" {
  value = random_string.random
}