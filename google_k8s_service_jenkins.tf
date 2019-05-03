resource "kubernetes_deployment" "terraform-jenkins" {
  metadata { name = "terraform-jenkins" namespace = "tools"

  labels {
    app = "jenkins-terraform-deployment" }
  }

  spec {
    replicas = 1

    selector { match_labels { app = "jenkins-pod" }
    }

    template {
      metadata { labels { app = "jenkins-pod" }
      }

      spec {
        container {
          image = "fsadykov/centos_jenkins:0.3"
          name  = "jenkins"

          volume_mount {
            name = "docker-sock"
            mount_path = "/var/run"
          }

        }

        volume {
          name = "docker-sock"
          host_path = { path = "/var/run" }
        }
      }
    }
  }
}


resource "kubernetes_service" "jenkins-service" {
  metadata {
    name = "jenkins-service"
    namespace = "tools"
  }

  spec {
    port {

      protocol = "TCP"
      port = 8080
      target_port = 8080
    }
    selector { app = "jenkins-pod" }
    type = "NodePort"
  }
}
