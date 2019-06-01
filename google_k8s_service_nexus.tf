resource "kubernetes_persistent_volume_claim" "nexus_pvc" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name = "nexus-pvc"

    namespace = "${var.namespace}"

    labels {
      app = "nexus-fuchicorp-deployment"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "20Gi"
      }
    }

    storage_class_name = "standard"
  }
}

resource "kubernetes_deployment" "nexus_fuchicorp_deployment" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name = "nexus-fuchicorp-deployment"

    namespace = "${var.namespace}"

    labels {
      app = "nexus-fuchicorp-deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "nexus-fuchicorp-deployment"
      }
    }

    template {
      metadata {
        labels {
          app = "nexus-fuchicorp-deployment"
        }
      }

      spec {
        volume {
          name = "nexus-pvc"

          persistent_volume_claim {
            claim_name = "nexus-pvc"
          }
        }

        container {
          name = "nexus-container"

          image = "fsadykov/docker-nexus"

          port {
            name           = "nexus-http"
            container_port = 8081
          }

          port {
            name           = "docker-repo"
            container_port = 8085
          }

          env {
            name  = "INSTALL4J_ADD_VM_PARAMS"
            value = "-Xms1200M -Xmx1200M -XX:MaxDirectMemorySize=2G -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
          }

          resources {
            requests {
              memory = "4800Mi"
              cpu    = "500m"
            }
          }

          volume_mount {
            name       = "nexus-pvc"
            mount_path = "/nexus-data"
          }

          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_service" "nexus_fuchicorp_service" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name = "nexus-fuchicorp-service"

    namespace = "${var.namespace}"
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = "${var.nexus_service_port}"
      target_port = 8081
    }

    port {
      name        = "docker-repo"
      protocol    = "TCP"
      port        = 8085
      target_port = 8085
    }

    selector {
      app = "nexus-fuchicorp-deployment"
    }

    type = "NodePort"
  }
}
