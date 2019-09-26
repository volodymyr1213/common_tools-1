
data "template_file" "values" {
  template = "${file("charts/jenkins/jenkins_values_template.yaml")}"

  vars {
    jenkins_user     = "${var.jenkins["admin_user"]}"
    jenkins_pass     = "${var.jenkins["admin_password"]}"
    clusterSubDomain = "fuchicorp.com"
  }
}

resource "local_file" "jenkins_helm_chart_values" {
  content  = "${trimspace(data.template_file.values.rendered)}"
  filename = "charts/.cache/jenkins_values.yaml"
}

resource "null_resource" "jenkins" {

  triggers {
    values = "${md5(data.template_file.values.rendered)}"
  }

  provisioner "local-exec" {
    command = "helm upgrade --install --namespace tools --values charts/.cache/jenkins_values.yaml jenkins-fuchicorp ./charts/jenkins"
  }
}

resource "null_resource" "jenkins_destroy" {
  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
      helm delete --purge jenkins
    EOF
  }
}
