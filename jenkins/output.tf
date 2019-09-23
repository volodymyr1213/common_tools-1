
//kops get secrets kube --type secret -oplaintext --state s3://mcd-tfstate/kops --name uskops1.mcdecp.datapipe.net
output "jenkins_admin_user" {
  value = "${var.jenkins["admin_user"]}"
}

//kops get secrets kube --type secret -oplaintext --state s3://mcd-tfstate/kops --name uskops1.mcdecp.datapipe.net
output "jenkins_admin_password" {
  value = "${var.jenkins["admin_password"]}"
}
