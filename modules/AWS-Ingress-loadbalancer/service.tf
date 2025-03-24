resource "kubernetes_service" "app_service" {
  metadata {
    name      = "app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "my-app"  # This must match your deployment's labels
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80  # Port on your pod
    }

    type = "ClusterIP"
  }
}
