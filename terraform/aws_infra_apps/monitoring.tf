locals {
  # common vars
  kubernetes_node_assignment = "monitoring"
  # prometheus
  prometheus_name            = "prometheus"
  prometheus_repository      = "https://kubernetes-charts.storage.googleapis.com/"
  prometheus_chart_version   = "11.6.0"
  prometheus_service_port    = "9090"
  # loki
  loki_name                  = "loki"
  loki_version               = "0.38.1"
  loki_repository            = "https://grafana.github.io/loki/charts"
  # grafana
  grafana_name               = "grafana"
  grafana_repository         = "https://kubernetes-charts.storage.googleapis.com/"
  grafana_chart_version      = "5.2.1"
  grafana_service_port       = "3000"
}

# prometheus
resource "helm_release" "prometheus_release" {
  depends_on       = [helm_release.ingress-nginx-controller]
  name             = local.prometheus_name
  chart            = local.prometheus_name
  version          = local.prometheus_chart_version
  repository       = local.prometheus_repository
  namespace        = local.kubernetes_node_assignment
  replace          = "false"
  create_namespace = "true"
  lint             = "true"
  values           = ["${file("values/prometheus.yaml")}"]
}

resource "kubernetes_ingress" "prometheus" {
  depends_on = [helm_release.prometheus_release]

  spec {
    backend {
      service_name = local.prometheus_name
      service_port = local.prometheus_service_port
    }
    rule {
      http {
        path {
          backend {
            service_name = local.prometheus_name
            service_port = local.prometheus_service_port
          }
          path = "/"
        }
      }
    }
  }
  metadata {
    name      = local.prometheus_name
    namespace = local.kubernetes_node_assignment
  }
}

# loki
resource "helm_release" "loki_release" {
  depends_on       = [helm_release.ingress-nginx-controller]
  name             = local.loki_name
  chart            = "${local.loki_name}-stack"
  version          = local.loki_version
  repository       = local.loki_repository
  namespace        = local.kubernetes_node_assignment
  replace          = "false"
  create_namespace = "true"
  lint             = "true"
  values           = ["${file("values/loki.yaml")}"]
}

# grafana
resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "#$^&*"
}

resource "helm_release" "grafana_release" {
  depends_on       = [helm_release.prometheus_release, helm_release.loki_release]
  name             = local.grafana_name
  chart            = local.grafana_name
  version          = local.grafana_chart_version
  repository       = local.grafana_repository
  namespace        = local.kubernetes_node_assignment
  replace          = "false"
  create_namespace = "true"
  lint             = "true"
  values           = ["${file("values/grafana.yaml")}"]

  set {
    name  = "adminPassword"
    value = random_string.random.result
  }
}
