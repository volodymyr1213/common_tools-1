data "template_file" "prometheus_values" {
  template = "${file("helm-prometheus/prometheus/prometheus_values_template.yaml")}"

  vars {
    deployment_endpoint = "${var.prometheus["prometheus_endpoint"]}"
  }
}

resource "local_file" "prometheus_helm_chart_values" {
  content  = "${trimspace(data.template_file.prometheus_values.rendered)}"
  filename = "helm-prometheus/.cache/prometheus_values.yaml"
}

resource "helm_release" "helm_prometheus_fuchicorp" {
  depends_on = [
    "kubernetes_service.vault_fuchicorp_service",
  ]

  values = [
    "${data.template_file.prometheus_values.rendered}",
  ]

  name      = "prometheus"
  namespace = "${var.deployment_environment}"
  chart     = "./helm-prometheus/prometheus"
}
