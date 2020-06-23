### nginx-ingress
# https://www.terraform.io/docs/providers/helm/r/release.html
resource "helm_release" "nginx-ingress" {
  name             = "nginx"
  chart            = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress"
  replace          = "true"
  create_namespace = "true"
  atomic           = "true"
  lint             = "true"


  set {
    name  = "nginx.ingress.kubernetes.io.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "nginx.ingress.kubernetes.io.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }

  set {
    type  = "string"
    name  = "nginx.ingress.kubernetes.io.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = "60"
  }

  set {
    type  = "string"
    name  = "nginx.ingress.kubernetes.io.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
  }

}
