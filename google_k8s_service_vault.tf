## FuchiCorp Vault Deployment
module "vault_deploy" {
  source                 = "fuchicorp/chart/helm"
  deployment_name        = "${var.vault["vault-name"]}"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "test-vault.${var.google_domain_name}"
  deployment_path        = "vault"

  template_custom_vars = {

    null_depends_on      = "${null_resource.cert_manager.id}"
    vault_service_port   = "${var.vault["vault_service_port"]}"
    vault_auth_secret    = "${var.vault["vault_auth_secret"]}"
    vault_auth_client_id = "${var.vault["vault_auth_client_id"]}"
    git_token            = "${var.vault["git_token"]}"
  }
}


