data "template_file" "template_values" {
  template = "${file("./helm-grafana/template_values.yaml")}"

  vars = {
    deployment_endpoint     = "grafana.${var.google_domain_name}"
    datasource_dns_endpoint = "https://prometheus.${var.google_domain_name}"
    grafana_password        = "${var.grafana["grafana_password"]}"
    grafana_username        = "${var.grafana["grafana_username"]}"
    grafana_client_secret   = "${var.grafana["grafana_client_secret"]}"
    grafana_auth_client_id  = "${var.grafana["grafana_auth_client_id"]}"
  }
}

resource "local_file" "grafana_values_local_file" {
  content  = "${trimspace(data.template_file.template_values.rendered)}"
  filename = "./helm-grafana/.cache/values.yaml"
}

resource "helm_release" "grafana" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ]
  name      = "${var.grafana["grafana-name"]}"
  namespace = "${var.deployment_environment}"
  chart     = "./helm-grafana"
  version   = "${var.grafana["grafana-version"]}"

  values = [
    "${data.template_file.template_values.rendered}",
  ]
}
