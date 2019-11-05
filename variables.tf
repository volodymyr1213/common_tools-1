###############                             ######################
############### Grafana Section Starts Right Here ################
###############                             ######################
variable "grafana-deployment_environment" {
  default = "tools"
}

variable "grafana-dns_endpoint_grafana" {
  type = "map"

  default = {
    tools = "grafana.fuchicorp.com"
  }
}

variable "version" {
  default = "6.0.1"
}

########### Put datasource or Prometheus endpoint as below ##############

variable "grafana-datasource_dns_endpoint" {
  default = "https://test-prometheus.fuchicorp.com"
}

variable "grafana-version" {
  default = "6.0.1"
}

variable "grafana-name" {
  default = "grafana"
}

variable "grafana_username" {
  default = "admin"
}

variable "grafana_password" {}

###############                             ######################
############### Grafana Section Ends Right Here ################
###############                             ######################

variable "namespace" {
  default = "tools"
}

variable "vault_token" {
  default = "Redhat"
}

variable "git_token" {
  default = "this-is-git-token"
}

variable "grafana_service_port" {
  default     = 8080
  description = "Please do not change this ports."
}

variable "vault_service_port" {
  default     = 8082
  description = "Please do not change this ports."
}

variable "nexus_service_port" {
  default     = 8083
  description = "Please do not change this ports."
}

variable "tiller_version" {
  default     = "v2.11.0"
  description = "Please provide version of the tiller."
}

variable "tiller_namespace" {
  default     = "kube-system"
  description = "Tiller by default will deploy to kube-system"
}

variable "repo_port" {
  default = 8085
}

variable "email" {
  default = "fuchicorpsolutions@gmail.com"
}

variable "project" {
  default = "fuchicorp-project-256020"
}

variable "jenkins" {
  type = "map"
}

# Github Integration for Jenkins Master
variable "jenkins_auth_client_id" {}

variable "jenkins_auth_secret" {}
