terraform import "kubernetes_secret.nexus_creds_namespaces[0]" "dev-students/nexus-creds"
terraform import "kubernetes_secret.nexus_creds_namespaces[1]" "qa-students/nexus-creds"
terraform import "kubernetes_secret.nexus_creds_namespaces[2]" "prod-students/nexus-creds"
terraform import "kubernetes_secret.nexus_creds_namespaces[3]" "dev/nexus-creds"
terraform import "kubernetes_secret.nexus_creds_namespaces[4]" "qa/nexus-creds"
terraform import "kubernetes_secret.nexus_creds_namespaces[5]" "prod/nexus-creds"
terraform import "kubernetes_secret.nexus_creds_namespaces[6]" "test/nexus-creds"



terraform state rm kubernetes_secret.nexus_creds_namespaces.dev-students
terraform state rm kubernetes_secret.nexus_creds_namespaces.qa-students
terraform state rm kubernetes_secret.nexus_creds_namespaces.prod_namespace
terraform state rm kubernetes_secret.nexus_creds_namespaces.qa
terraform state rm kubernetes_secret.nexus_creds_namespaces.prod
terraform state rm kubernetes_secret.nexus_creds_namespaces.test
terraform state rm kubernetes_secret.nexus_creds_namespaces.dev