module "dashboard_deployer" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "dashboard-${var.deployment_environment}"
  deployment_environment = "kube-system"
  deployment_endpoint    = "dashboard.${var.google_domain_name}"
  deployment_path        = "kubernetes-dashboard"

  template_custom_vars    = {
    null_depends_on       = "${null_resource.cert_manager.id}"
  }
}