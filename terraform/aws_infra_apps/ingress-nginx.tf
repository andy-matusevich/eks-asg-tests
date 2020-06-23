### ingress-nginx
# https://www.terraform.io/docs/providers/helm/r/release.html
resource "helm_release" "ingress-nginx-controller" {
  name             = "nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  namespace        = "ingress"
  replace          = "true"
  create_namespace = "true"
  atomic           = "true"
  lint             = "true"


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

}

resource "kubernetes_config_map" "ingress-nginx-controller" {
  depends_on = [helm_release.ingress-nginx-controller]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress"
  }

  data = {
    ssl-redirect  = "false"
    #hsts          = "true"
    server-tokens = "false"
    http-snippet  = "server { listen 80 proxy_protocol; server_tokens off; return 301 https://$host$request_uri; }"

  }
}

resource "kubernetes_ingress" "ingress-nginx-controller" {
  depends_on = [kubernetes_config_map.ingress-nginx-controller]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "monitoring"
  }

  spec {
    backend {
      service_name = "grafana"
      service_port = 3000
    }
  }
}