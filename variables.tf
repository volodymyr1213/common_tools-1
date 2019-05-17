variable    "grafana_password"            {}
variable    "grafana_username"            {}
variable    "namespace"                   {
  default = "tools"
}
variable    "vault_token"                 {}

variable    "grafana_service_port"        {
  default = 8080
  description = "Please do not change this ports."
}

variable    "jenkins_service_port"     {
  default = 8081
  description = "Please do not change this ports."
}

variable    "jira_service_port"        {
  default = 8082
  description = "Please do not change this ports."
}

variable    "nexus_service_port"       {
  default = 8083
  description = "Please do not change this ports."
}

variable    "vault_service_port"       {
  default = 8084
  description = "Please do not change this ports."
}

variable "tiller_version" {
  default = "v2.11.0"
  description = "Please provide version of the tiller."
}

variable "tiller_namespace" {
  default = "kube-system"
  description = "Tiller by default will deploy to kube-system"
}
