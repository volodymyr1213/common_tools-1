resource "null_resource" "ingress-applier" {

  provisioner "local-exec" {
    command = <<EOF
    helm install --name fuchicorp-services-ingress  --namespace "${lower(var.namespace)}" \
    --set-string grafanaport=${var.grafana_service_port} \
    --set-string jenkinsport=${var.jenkins_service_port} \
    --set-string jiraport=${var.jira_service_port} \
    --set-string nexusport=${var.nexus_service_port} \
    --set-string vaultport=${var.vault_service_port}  ./helm-fuchicorp

    EOF
  }
}


resource "null_resource" "ingress-destroyer" {

  provisioner "local-exec" {
    when = "destroy"

    command = "helm del --purge fuchicorp-services-ingress"

  }
}
