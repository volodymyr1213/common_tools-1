data "template_file" "jenkins_values" {
  template = "${file("helm-jenkins/jenkins/jenkins_values_template.yaml")}"

  vars {
    jenkins_user           = "${var.jenkins["admin_user"]}"
    jenkins_pass           = "${var.jenkins["admin_password"]}"
    deployment_endpoint     = "jenkins.${var.google_domain_name}"
    jenkins_auth_secret    = "${var.jenkins["jenkins_auth_secret"]}"
    jenkins_auth_client_id = "${var.jenkins["jenkins_auth_client_id"]}"
    git_token              = "${var.jenkins["git_token"]}"
  }
}

resource "local_file" "jenkins_helm_chart_values" {
  content  = "${trimspace(data.template_file.jenkins_values.rendered)}"
  filename = "helm-jenkins/.cache/jenkins_values.yaml"
}

resource "helm_release" "helm_jenkins" {
  depends_on = [
    "kubernetes_deployment.vault_deployment",
    "kubernetes_service.vault_service",
    "kubernetes_service.nexus_service",
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ] #  "kubernetes_deployment.nexus_deployment",

  values = [
    "${data.template_file.jenkins_values.rendered}",
  ]

  name      = "jenkins"
  namespace = "${var.deployment_environment}"
  chart     = "./helm-jenkins/jenkins"
}
