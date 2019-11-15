data "template_file" "template_values" {
  template = "${file("./helm-grafana/template_values.yaml")}"

  vars = {
    deployment_endpoint = "${lookup(var.grafana-dns_endpoint_grafana, "${var.deployment_environment}")}"

    datasource_dns_endpoint = "${var.grafana["grafana-datasource_dns_endpoint"]}"
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
  name      = "${var.grafana["grafana-name"]}"
  namespace = "${var.deployment_environment}"
  chart     = "./helm-grafana"
  version   = "${var.grafana["grafana-version"]}"

  values = [
    "${data.template_file.template_values.rendered}",
  ]
}
