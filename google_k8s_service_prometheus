data "template_file" "prometheus_values" {
  template = "${file("helm-prometheus/prometheus/prometheus_values_template.yaml")}"

  vars {
    deployment_endpoint = "prometheus.${var.google_domain_name}"
  }
}

resource "local_file" "prometheus_helm_chart_values" {
  content  = "${trimspace(data.template_file.prometheus_values.rendered)}"
  filename = "helm-prometheus/.cache/prometheus_values.yaml"
}

resource "helm_release" "helm_prometheus" {

  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_service.vault_service",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ]

  values = [
    "${data.template_file.prometheus_values.rendered}",
  ]

  name      = "prometheus"
  namespace = "${var.deployment_environment}"
  chart     = "./helm-prometheus/prometheus"
}
