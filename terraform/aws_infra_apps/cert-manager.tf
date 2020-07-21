locals {
  # cert-manager
  cert_manager_name          = "cert-manager"
  cert_manager_repository    = "https://charts.jetstack.io"
  cert_manager_chart_version = "v0.15.2"
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = local.cert_manager_name
  }
}

resource "helm_release" "cert_manager_release" {
  depends_on       = [helm_release.prometheus_release]
  name             = local.cert_manager_name
  chart            = local.cert_manager_name
  version          = local.cert_manager_chart_version
  repository       = local.cert_manager_repository
  namespace        = local.cert_manager_name
  replace          = "false"
  values           = [file("values/cert-manager.yaml")]
}