module "dashboard_deployer" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "dashboard-${var.deployment_environment}"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "dashboard.${var.google_domain_name}"
  deployment_path        = "kubernetes-dashboard"


}