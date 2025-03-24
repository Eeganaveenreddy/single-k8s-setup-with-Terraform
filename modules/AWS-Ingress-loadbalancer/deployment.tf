resource "kubernetes_deployment" "app" {
  metadata {
    name      = "my-app"
    namespace = "default"
    labels = {
      app = "my-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = "nginx:latest"  # Change this to your application image
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
