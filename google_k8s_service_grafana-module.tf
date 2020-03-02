module "helm_deploy" {
  source                 = "git::https://github.com/fuchicorp/helm-deploy.git"
  deployment_name        = "grafanatest"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "grafanatest.${var.google_domain_name}"
  deployment_path        = "grafana"

  template_custom_vars = {
    
    
    datasource_dns_endpoint  = "https://prometheus.${var.google_domain_name}"
    grafana_password         = "${var.grafana["grafana_password"]}"
    grafana_username         = "${var.grafana["grafana_username"]}"
    grafana_auth_client_id   = "${var.grafana["grafana_client_secret"]}"
    grafana_client_secret    = "${var.grafana["grafana_auth_client_id"]}"
  }
 

}