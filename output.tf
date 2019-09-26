

// Print admin user name after deployment
output "jenkins_endpoint" {
  value = "jenkins.fuchicorp.com"
}


// Print admin user name after deployment
output "jenkins_user" {
  value = "${var.jenkins["admin_user"]}"
}


// Print admin password after deployment
output "jenkins_password" {
  value = "${var.jenkins["admin_password"]}"
}


// FuchiCorp Slack Python Token
output "slack_python_token" {
  value = "${var.slack_python_token}"
}


// FuchiCorp Vault Token
output "fuchicorp_vault_token" {
  value = "${var.vault_token}"
}


// FuchiCorp Grafana Username
output "grafana_username" {
  value = "${var.grafana_username}"
}


// FuchiCorp Grafana Username
output "grafana_password" {
  value = "${var.grafana_password}"
}


// FuchiCorp Grafana url
output "grafana_endpoint" {
  value = "grafana.fuchicorp.com"
}
