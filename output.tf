// Print how looks like Jenkins data
output "jenkins" {
  value = "${var.jenkins}"
}

// FuchiCorp Vault output
output "vault_token" {
  value = "${var.vault_token}"
}

// FuchiCorp Grafana deployment output
output "grafana" {
  value = "${var.grafana}"
}
