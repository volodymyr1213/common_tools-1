data "template_file" "tags" {
  count    = "${length(module.resource_tagging.tags)}"
  template = "$${k}=$${v}"

  vars {
    k = "${trimspace(element(keys(module.resource_tagging.tags), count.index))}"
    v = "${trimspace(element(values(module.resource_tagging.tags), count.index))}"
  }
}

data "template_file" "values" {
  template = "${file("charts/jenkins/jenkins_values_template.yaml")}"

  vars {
    clusterSubDomain = "${data.terraform_remote_state.base_kops_config.cluster1_name}"
    tags             = "${join(",", data.template_file.tags.*.rendered)}"
    existing_pvc     = "${length(var.existing_pvc) > 0 ? "ExistingClaim: ${var.existing_pvc}" : ""}"
    jenkins_user     = "${var.jenkins["admin_user"]}"
    jenkins_pass     = "${var.jenkins["admin_password"]}"
    vet_tools_image  = "${var.vet_tools_image}:${var.vet_tools_image_tag}"
    newrelic_license = "${var.newrelic_license}"
    java_agent_opt   = "${var.newrelic_license != "" ? "-javaagent:/var/jenkins_home/newrelic/newrelic.jar":""}"
  }
}

resource "local_file" "jenkins_helm_chart_values" {
  content  = "${trimspace(data.template_file.values.rendered)}"
  filename = "charts/.cache/jenkins_values.yaml"
}

resource "null_resource" "jenkins" {
  depends_on = ["null_resource.get_kube_config"]

  triggers {
    values = "${md5(data.template_file.values.rendered)}"
  }

  provisioner "local-exec" {
    command = "helm upgrade --install --namespace jenkins --tiller-namespace tiller-full --wait --kube-context=${data.terraform_remote_state.base_kops_config.cluster1_name} --values charts/.cache/jenkins_values.yaml jenkins ./charts/jenkins"
  }
}

resource "null_resource" "jenkins_destroy" {
  depends_on = ["null_resource.get_kube_config"]

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
      echo 'helm delete --dry-run --purge jenkins --tiller-namespace tiller-full --kube-context=${data.terraform_remote_state.base_kops_config.cluster1_name}'
      true
    EOF
  }
}
