resource "helm_release" "prometheus" {
  name             = "prometheus"
  chart            = "prometheus"
#  version          = "11.6.0"
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

resource "helm_release" "grafana" {
  name             = "grafana"
  chart            = "grafana"
#  version          = "5.2.1"
  repository       = "https://kubernetes-charts.storage.googleapis.com/"
  namespace        = "monitoring"
  replace          = "false"
  create_namespace = "true"
  lint             = "true"
  values           = ["${file("manifests/grafana.yaml")}"]
  depends_on       = [helm_release.prometheus]

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

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "#$^&*"
}