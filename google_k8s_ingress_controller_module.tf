module "ingress_controller" {
  source  = "fuchicorp/chart/helm"
  version = "0.0.2"
  deployment_name        = "ingress-controller-${var.deployment_environment}"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "ingress-controller.${var.google_domain_name}"
  deployment_path        = "./ingress-controller"


}


