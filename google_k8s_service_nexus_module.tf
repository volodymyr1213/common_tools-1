module "nexus_deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "nexus"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "nexus.${var.google_domain_name}"
  deployment_path        = "nexus"

  
  template_custom_vars = {
    
    docker_endpoint          = "docker.${var.google_domain_name}"
    nexus_port               = "${var.nexus_service_port}"
    repo_port                = "${var.repo_port}"
  }
}
