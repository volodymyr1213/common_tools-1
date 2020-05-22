data "template_file" "docker_config_template" {
  template = "${file("${path.module}/terraform_templates/config_template.json")}"

  vars {
    docker_endpoint = "docker.${var.google_domain_name}"
    user_data = "${base64encode(var.secret_config["user_data"])}"
  }
}

resource "kubernetes_secret" "nexus_creds" {
  metadata {
    name = "nexus-creds"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_template.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "nexus_creds_namespaces" {
  count = "${length(var.namespaces)}"

  metadata {
    name = "nexus-creds"
    namespace = "${var.namespaces[count.index]}"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_template.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}