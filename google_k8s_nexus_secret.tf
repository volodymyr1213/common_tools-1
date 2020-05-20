data "template_file" "docker_config_template" {
  template = "${file("${path.module}/.docker/config_template.json")}"

  vars {
    docker_endpoint = "${var.secret_config["docker_endpoint"]}"
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
