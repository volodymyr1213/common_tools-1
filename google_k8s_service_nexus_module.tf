module "nexus_deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "nexus"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "nexus.${var.google_domain_name}"
  deployment_path        = "sonatype-nexus"

  template_custom_vars = {
    docker_endpoint          = "docker.${var.google_domain_name}"
    repo_port                = "${var.repo_port}"
  }
}
