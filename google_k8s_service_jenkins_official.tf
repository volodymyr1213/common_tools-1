data "template_file" "jenkins_values" {
  template = "${file("helm-jenkins/jenkins/jenkins_values_template.yaml")}"

  vars {
    jenkins_user           = "${var.jenkins["admin_user"]}"
    jenkins_pass           = "${var.jenkins["admin_password"]}"
    cluster_sub_domain     = "fuchicorp.com"
    jenkins_auth_secret    = "${var.jenkins_auth_secret}"
    jenkins_auth_client_id = "${var.jenkins_auth_client_id}"
    git_token              = "${var.git_token}"
  }
}

resource "local_file" "jenkins_helm_chart_values" {
  content  = "${trimspace(data.template_file.jenkins_values.rendered)}"
  filename = "helm-jenkins/.cache/jenkins_values.yaml"
}

resource "helm_release" "helm_jenkins_fuchicorp" {
  depends_on = [
    "helm_release.ingress_controller",
    "helm_release.grafana",
    "kubernetes_deployment.vault_fuchicorp_deployment",
    "kubernetes_deployment.nexus_fuchicorp_deployment",
    "kubernetes_service.vault_fuchicorp_service",
    "kubernetes_service.nexus_fuchicorp_service",
  ]

  values = [
    "${data.template_file.jenkins_values.rendered}",
  ]

  name      = "jenkins-fuchicorp"
  namespace = "${var.namespace}"
  chart     = "./helm-jenkins/jenkins"
}
