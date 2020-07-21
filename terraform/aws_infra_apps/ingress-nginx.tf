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
  recreate_pods    = "true"

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

  set {
    type  = "string"
    name  = "controller.podAnnotations.prometheus\\.io/scrape"
    value = "true"
  }

  set {
    type  = "string"
    name  = "controller.podAnnotations.prometheus\\.io/path"
    value = "/metrics"
  }

  set {
    type  = "string"
    name  = "controller.podAnnotations.prometheus\\.io/port"
    value = "10254"
  }
}

# https://www.terraform.io/docs/providers/kubernetes/r/config_map.html
resource "kubernetes_config_map" "ingress-nginx-controller" {
  depends_on = [helm_release.ingress-nginx-controller]

  metadata {
    name      = helm_release.ingress-nginx-controller.name
    namespace = helm_release.ingress-nginx-controller.namespace
  }

}

# https://www.terraform.io/docs/providers/aws/d/lb.html
data "aws_lb" "ingress-nginx-controller" {
  depends_on = [helm_release.ingress-nginx-controller]

  tags = {
    "kubernetes.io/service-name" = "ingress/nginx-ingress-nginx-controller"
  }
}
