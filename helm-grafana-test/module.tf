module "helm_deploy" {
  source                 = "git::https://github.com/fuchicorp/helm-deploy.git"
  deployment_name        = "grafana-test"
  deployment_environment = "tools"
  deployment_endpoint    = "graf.tazagul.net"
  deployment_path        = "grafana"

  template_custom_vars = {
    grafana_username      = "admin"
    grafana_password      = "password"
    datasource_dns_endpoint = "https://prometheus.tazagul.net"
    grafana_auth_client_id  = "f008e522b08409abed9a"
    grafana_client_secret   = "1b32dacc6c7462dd109573d8305bb0b16e1dc84c"
  }
 

}