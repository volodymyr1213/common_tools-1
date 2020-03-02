module "helm_deploy" {
  source                 = "git::https://github.com/fuchicorp/helm-deploy.git"
  deployment_name        = "grafana-test"
  deployment_environment = "default"
  deployment_endpoint    = "graf.tazagul.net"
  deployment_path        = "grafana"
}