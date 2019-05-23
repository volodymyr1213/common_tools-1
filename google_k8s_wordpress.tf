resource "kubernetes_secret" "mysql_creds" {
  metadata {
    name = "mysql-creds"
  }

  data {
    MYSQL_ROOT_PASSWORD = "${var.mysql_password}"
    MYSQL_USER_PASSWORD = "${var.mysql_password}"
  }

  type = "Opaque"
}

resource "kubernetes_persistent_volume_claim" "mysql_pv_claim" {
  metadata {
    name = "mysql-pv-claim"
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
  metadata {
    name = "wp-lv-claim"

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

resource "kubernetes_deployment" "fuchicorp_mysql" {
  metadata {
    name = "fuchicorp-mysql"

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
                name = "mysql-creds"
                key  = "MYSQL_ROOT_PASSWORD"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-creds"
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

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"

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
            value = "fuchicorp-mysql"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "fuchicorp"
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-creds"
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

resource "kubernetes_service" "fuchicorp_mysql" {
  metadata {
    name = "fuchicorp-mysql"

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

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"

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

resource "kubernetes_service" "wordpress_tools" {
  metadata {
    name      = "wordpress-tools"
    namespace = "tools"
  }

  spec {
    port {
      port        = "${var.wordpress_tools_service_port}"
      target_port = "${var.wordpress_service_port}"
    }

    type          = "ExternalName"
    external_name = "wordpress.default.svc.cluster.local"
  }
}