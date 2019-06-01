resource "kubernetes_secret" "mysql_secrets" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "mysql-secrets"
    namespace = "${var.wordpress_namespace}"
  }

  data {
    MYSQL_ROOT_PASSWORD = "${var.mysql_password}"
    MYSQL_USER_PASSWORD = "${var.mysql_password}"
  }

  type = "Opaque"
}

resource "kubernetes_persistent_volume_claim" "mysql_pv_claim" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "mysql-pv-claim"
    namespace = "${var.wordpress_namespace}"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "10Gi"
      }
    }

    storage_class_name = "standard"
  }
}

resource "kubernetes_persistent_volume_claim" "wp_lv_claim" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "wp-lv-claim"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "wordpress"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "mysql_fuchicorp_deployment" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "mysql-fuchicorp-deployment"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "fuchicorp"
    }
  }

  spec {
    selector {
      match_labels {
        app  = "fuchicorp"
        tier = "mysql"
      }
    }

    template {
      metadata {
        labels {
          app  = "fuchicorp"
          tier = "mysql"
        }
      }

      spec {
        volume {
          name = "mysql-local-storage"

          persistent_volume_claim {
            claim_name = "mysql-pv-claim"
          }
        }

        container {
          name  = "mysql"
          image = "fsadykov/centos_mysql"

          port {
            name           = "mysql"
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "MYSQL_ROOT_PASSWORD"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "MYSQL_USER_PASSWORD"
              }
            }
          }

          env {
            name  = "MYSQL_USER"
            value = "fuchicorp"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "fuchicorp"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_deployment" "wordpress_fuchicorp_deployment" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "wordpress-fuchicorp-deployment"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels {
        app = "wordpress"
      }
    }
    template {
      metadata {
        labels {
          tier = "frontend"
          app  = "wordpress"
        }
      }

      spec {
        volume {
          name = "wordpress-local-storage"

          persistent_volume_claim {
            claim_name = "wp-lv-claim"
          }
        }

        container {
          name  = "wordpress"
          image = "wordpress:5.1.1-php7.1-apache"

          port {
            name           = "wordpress"
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "fuchicorp-mysql-service"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "fuchicorp"
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "MYSQL_USER_PASSWORD"
              }
            }
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "fuchicorp"
          }

          volume_mount {
            name       = "wordpress-local-storage"
            mount_path = "/var/www/html"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "fuchicorp_mysql_service" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "fuchicorp-mysql-service"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "fuchicorp"
    }
  }

  spec {
    port {
      port = 3306
    }

    selector {
      app  = "fuchicorp"
      tier = "mysql"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "fuchicorp_wordpress_service" {
  depends_on = ["kubernetes_namespace.prod"]
  metadata {
    name = "fuchicorp-wordpress-service"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "wordpress"
    }
  }

  spec {
    port {
      port        = "${var.wordpress_service_port}"
      target_port = "80"
    }

    selector {
      app  = "wordpress"
      tier = "frontend"
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "fuchicorp_wordpress_tools_service" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name      = "fuchicorp-wordpress-tools-service"
    namespace = "${var.namespace}"
  }

  spec {
    port {
      port        = "${var.wordpress_tools_service_port}"
      target_port = "${var.wordpress_service_port}"
    }

    type          = "ExternalName"
    external_name = "fuchicorp-wordpress-service.${var.wordpress_namespace}.svc.cluster.local"
  }
}
