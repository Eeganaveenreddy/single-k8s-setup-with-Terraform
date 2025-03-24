resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "app-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"                    = "alb"
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"  # Change to "internal" if needed
      "alb.ingress.kubernetes.io/load-balancer-type"   = "nlb"  # Use NLB instead of ALB
      "alb.ingress.kubernetes.io/target-type"          = "ip"
      "alb.ingress.kubernetes.io/healthcheck-path"     = "/"   # Adjust to your app
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "80"
      # "alb.ingress.kubernetes.io/security-groups" = aws_security_group.nlb_sg.id
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds": "10"
      "alb.ingress.kubernetes.io/success-codes": "200"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "cloudops-platforms.cloud"  # Replace with your domain

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              # name = kubernetes_service.app_service.metadata[0].name
              name = "app-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
