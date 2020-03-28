# Deploy cert manger
resource "helm_release" "cert_manager" {
  depends_on = [
    "null_resource.cert_manager"
  ]

  name      = "cert-manager"
  chart     = "jetstack/cert-manager"
  namespace = "${var.deployment_environment}"

  wait = true
}

resource "null_resource" "cert_manager" {
  depends_on = [
    "null_resource.helm_init"
  ]
  provisioner "local-exec" {
    command = <<EOF
    helm repo add jetstack https://charts.jetstack.io
    kubectl apply --validate=false  -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
    EOF
  }
}
