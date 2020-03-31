## FuchiCorp Vault Deployment
module "vault_deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "${var.vault["vault-name"]}"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "test-vault.${var.google_domain_name}"
  deployment_path        = "vault"

  template_custom_vars = {

    null_depends_on          = "${null_resource.cert_manager.id}"
    vault_username           = "${var.vault["vault_username"]}"
    vault_service_port       = "${var.vault["vault_service_port"]}"
    vault_token              = "${var.vault["vault_token"]}"
    
  }
}


# resource "kubernetes_deployment" "vault_deployment" {
#   depends_on = ["kubernetes_namespace.service_tools"]
#   depends_on = ["kubernetes_secret.vault_secret"]

#   metadata {
#     name = "vault-deployment"

#     namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"

#     labels {
#       app = "vault-deployment"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels {
#         app = "vault-deployment"
#       }
#     }

#     template {
#       metadata {
#         labels {
#           app = "vault-deployment"
#         }
#       }

#       spec {
#         volume {
#           name = "vault-pvc"

#           persistent_volume_claim {
#             claim_name = "vault-pvc"
#           }
#         }

#         container {
#           name  = "vault"
#           image = "vault"

#           port {
#             container_port = 8200
#             protocol       = "TCP"
#           }

#           security_context {
#             capabilities {
#               add = ["IPC_LOCK"]
#             }
#           }

#           env {
#             name = "VAULT_DEV_ROOT_TOKEN_ID"

#             value_from {
#               secret_key_ref {
#                 name = "vault-secret"
#                 key  = "token"
#               }
#             }
#           }

#           volume_mount {
#             name       = "vault-pvc"
#             mount_path = "/var/run"
#           }
#         }
#       }
#     }
#   }
# }

# ## Vault Persistent Volume Claim
# resource "kubernetes_persistent_volume_claim" "vault_pvc" {
#   depends_on = [
#     "kubernetes_namespace.service_tools",
#     "kubernetes_secret.vault_secret" ]

#   metadata {
#     name = "vault-pvc"

#     namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"

#     labels {
#       app = "vault-deployment"
#     }
#   }

#   spec {
#     access_modes = ["ReadWriteOnce"]

#     resources {
#       requests {
#         storage = "1Gi"
#       }
#     }
#   }
# }

# ## FuchiCorp vault secret
# resource "kubernetes_secret" "vault_secret" {
#   depends_on = ["kubernetes_namespace.service_tools"]
#   metadata {
#     name = "vault-secret"

#     namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"
#   }

#   data {
#     token = "${var.vault_token}"
#   }

#   type = "Opaque"
# }

# resource "kubernetes_service" "vault_service" {
#   depends_on = ["kubernetes_namespace.service_tools"]
#   depends_on = ["kubernetes_secret.vault_secret"]

#   metadata {
#     name = "vault-service"

#     namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"
#   }

#   spec {
#     selector {
#       app = "vault-deployment"
#     }

#     port {
#       protocol    = "TCP"
#       port        = "${var.vault_service_port}"
#       target_port = 8200
#     }

#     type = "ClusterIP"
#   }
# }
