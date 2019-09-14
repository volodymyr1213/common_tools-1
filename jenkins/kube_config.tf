resource "null_resource" "get_kube_config" {
  provisioner "local-exec" {
    command = <<EOF
        export NAME="${lower(var.environment)}.${data.terraform_remote_state.base_kops_config.base_domain}"
        export KOPS_STATE_STORE=s3://${var.s3_bucket}/vet/${var.aws_region}/sharedtools/${var.environment}
        if [ ! -f $HOME/.kube/${lower(var.environment)}.${data.terraform_remote_state.base_kops_config.base_domain} ]; then
          kops export kubecfg "${lower(var.environment)}.${data.terraform_remote_state.base_kops_config.base_domain}"
        fi
    EOF
  }
}
