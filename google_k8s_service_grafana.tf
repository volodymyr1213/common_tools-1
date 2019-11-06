data "template_file" "template_values" {
  template = "${file("./helm-grafana/template_values.yaml")}"

  vars = {
    deployment_endpoint     = "${lookup(var.grafana-dns_endpoint_grafana, "${var.grafana-deployment_environment}")}"
    datasource_dns_endpoint = "${var.grafana-datasource_dns_endpoint}"
    grafana_password        = "${var.grafana_password}"
    grafana_username        = "${var.grafana_username}"

    # deployment_image = "${var.deployment_image}"
  }
}

resource "local_file" "grafana_values_local_file" {
  content  = "${trimspace(data.template_file.template_values.rendered)}"
  filename = "./helm-grafana/.cache/values.yaml"
}

resource "helm_release" "grafana" {
  name      = "${var.grafana-name}"
  namespace = "${var.grafana-deployment_environment}"
  chart     = "./helm-grafana"
  version   = "${var.grafana-version}"

  values = [
    "${data.template_file.template_values.rendered}",
  ]
}
