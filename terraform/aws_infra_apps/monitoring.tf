resource "helm_release" "prometheus" {
  depends_on       = [helm_release.ingress-nginx-controller]
  name             = "prometheus"
  chart            = "prometheus"
  version          = "11.6.0"
  repository       = "https://kubernetes-charts.storage.googleapis.com/"
  namespace        = "monitoring"
  replace          = "false"
  create_namespace = "true"
  lint             = "true"

  set {
    name  = "alertmanager\\.persistentVolume\\.storageClass"
    value = "gp2"
  }

  set {
    name  = "server\\.persistentVolume\\.storageClass"
    value = "gp2"
  }
}

resource "kubernetes_ingress" "prometheus" {
  depends_on = [helm_release.prometheus]

  spec {
    backend {
      service_name = "prometheus-server"
      service_port = "9090"
    }
    rule {
      http {
        path {
          backend {
            service_name = "prometheus-server"
            service_port = "9090"
          }
          path = "/"
        }
      }
    }
  }
  metadata {
    name      = "ingress-prometheus"
    namespace = "monitoring"
  }
}

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "#$^&*"
}

resource "helm_release" "grafana" {
  depends_on       = [kubernetes_ingress.prometheus]
  name             = "grafana"
  chart            = "grafana"
  version          = "5.2.1"
  repository       = "https://kubernetes-charts.storage.googleapis.com/"
  namespace        = "monitoring"
  replace          = "false"
  create_namespace = "true"
  lint             = "true"
  values           = ["${file("grafana/values.yaml")}"]


  set {
    name  = "persistence\\.storageClassName"
    value = "gp2"
  }

  set {
    name  = "persistence\\.enabled"
    value = "true"
  }

  set {
    name  = "adminPassword"
    value = random_string.random.result
  }


}

resource "kubernetes_ingress" "grafana" {
  depends_on             = [helm_release.grafana]
#  wait_for_load_balancer = "true"

  spec {
    backend {
      service_name = "grafana"
      service_port = "3000"
    }
    rule {
      http {
        path {
          backend {
            service_name = "grafana"
            service_port = "3000"
          }
          path = "/grafana(/|$)(.*)"
        }
      }
    }
  }
  metadata {
    name        = "ingress-grafana"
    namespace   = "monitoring"
    annotations = {
      rewrite-target = "/$2"
    }

  }
}
