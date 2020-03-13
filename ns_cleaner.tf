resource "kubernetes_service_account" "ns_cleaner_service_account" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller"
    ]
  metadata {
    name = "ns_cleaner_service_account"
    namespace = "${var.deployment_environment}"
  }
  secret {
    name = "${kubernetes_secret.ns_cleaner_secret.metadata.0.name}"
  }
  automount_service_account_token = true
}

resource "kubernetes_secret" "ns_cleaner_secret" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller"
    ]
  metadata {
    name = "ns_cleaner_service_account_secret"
    namespace = "${var.deployment_environment}"
  }
}

resource "kubernetes_cluster_role_binding" "ns_cleaner" {
  depends_on = [
    "kubernetes_secret.ns_cleaner_secret",
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller"
    ]
    metadata {
        name = "common-cluster-rule"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "cluster-admin"
    }
    subject {
        kind      = "ServiceAccount"
        name      = "${kubernetes_service_account.ns_cleaner_service_account.metadata.0.name}"
        namespace = "${kubernetes_service_account.ns_cleaner_service_account.metadata.0.namespace}"
    }
}