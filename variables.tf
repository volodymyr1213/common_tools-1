variable "deployment_environment" {
  default = "tools"
}

variable "grafana-dns_endpoint_grafana" {
  type = "map"

  default = {
    tools = "grafana.fuchicorp.com"
  }
}

variable "grafana-datasource_dns_endpoint" {
  default = "https://prometheus.fuchicorp.com/graph"
}

variable "cert_manager_version" {
  default = "v0.11.0"
}

variable "namespace" {
  default = "tools"
}

variable "vault_token" {
  default = "Redhat"
}

variable "git_token" {
  default = "this-is-git-token"
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

  default = {
    jenkins_endpoint       = "jenkins.fuchicorp.com"
    admin_user             = "admin"
    admin_password         = "password"
    jenkins_auth_client_id = "id"
    jenkins_auth_secret    = "secret"
  }
}

variable "grafana" {
  type = "map"

  default = {
    grafana_endpoint = "grafana.fuchicorp.com"
    grafana-version  = "6.0.1"
    grafana_username = "admin"
    grafana_password = "password"
    grafana-name     = "grafana"
  }
}

variable "prometheus" {
  type = "map"

  default = {
    prometheus_endpoint = "prometheus.fuchicorp.com"
  }
}
