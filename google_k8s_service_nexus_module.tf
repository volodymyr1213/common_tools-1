module "nexus_deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "nexus"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "nexus.${var.google_domain_name}"
  deployment_path        = "sonatype-nexus"

  template_custom_vars = {
    null_depends_on          = "${null_resource.helm_init.id}"
    docker_endpoint          = "docker.${var.google_domain_name}"
    repo_port                = "${var.repo_port}"
    nexus_password           = "${var.nexus_password}"
  }
}
