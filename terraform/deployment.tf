resource "kubernetes_deployment" "weatherapi" {
  metadata {
    name = "weatherapi"
    labels = {
      App = "weatherapi"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "weatherapi"
      }
    }
    template {
      metadata {
        labels = {
          App = "weatherapi"
        }
      }
      spec {
        container {
          image = "knagu/weatherapi:latest"
          name  = "weatherapi"

          port {
            container_port = 80
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "weatherapi" {
  metadata {
    name = "weatherapi"
  }
  spec {
    selector = {
      App = kubernetes_deployment.weatherapi.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}



