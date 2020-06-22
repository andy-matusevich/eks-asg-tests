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

  # /nginx-health
  set {
    type  = "string"
    name  = "controller.healthStatus"
    value = "true"
  }

}
