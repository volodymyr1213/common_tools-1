## Service account for tiller
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "${var.tiller_namespace}"
  }
  secret {
    name = "${kubernetes_secret.tiller.metadata.0.name}"
  }
}

## Secret for tillers service account
resource "kubernetes_secret" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "${var.tiller_namespace}"
  }
}

## Cluster role binding for tiller
resource "kubernetes_cluster_role_binding" "tiller_cluster_rule" {
    depends_on = [
      "kubernetes_service_account.tiller",
      "kubernetes_secret.tiller"
    ]
    metadata {
        name = "tiller-cluster-rule"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "cluster-admin"
    }
    subject {
        kind      = "ServiceAccount"
        name      = "${kubernetes_service_account.tiller.metadata.0.name}"
        namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
    }
}
