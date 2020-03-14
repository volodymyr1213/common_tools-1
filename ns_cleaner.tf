resource "kubernetes_service_account" "ns_cleaner_service_account" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller"
    ]

  metadata {
    name = "ns-cleaner-sa"
    namespace = "${var.deployment_environment}"
  }
}


resource "kubernetes_cluster_role_binding" "ns_cleaner_crb" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller"
    ]

    metadata {
        name = "ns-cleaner-crb"
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

resource "kubernetes_cron_job" "ns_cleaner_cronjob" {
  metadata {
    name = "ns-cleaner-cj"
    namespace = "${kubernetes_service_account.ns_cleaner_service_account.metadata.0.namespace}"
  }
  spec {
    successful_jobs_history_limit = 5
    failed_jobs_history_limit     = 5
    schedule                      = "*/1 * * * *"
    starting_deadline_seconds     = 20
    job_template {
      metadata {}
      spec {
        backoff_limit = 3
        template {
          metadata {}
          spec {
            service_account_name = "${kubernetes_service_account.ns_cleaner_service_account.metadata.0.name}"
            container {
              name    = "ns_cleaner"
              image   = "bitnami/kubectl:latest"
              command = ["/bin/sh", "-c", "kubectl delete configmaps,endpoints,events,limitranges,persistentvolumeclaims,pods,podtemplates,replicationcontrollers,resourcequotas,secrets,serviceaccounts,services,challenges.acme.cert-manager.io,orders.acme.cert-manager.io,controllerrevisions.apps,daemonsets.apps,deployments.apps,replicasets.apps,statefulsets.apps,horizontalpodautoscalers.autoscaling,cronjobs.batch,jobs.batch,certificaterequests.cert-manager.io,certificates.cert-manager.io,issuers.cert-manager.io,certificates.certmanager.k8s.io,challenges.certmanager.k8s.io,issuers.certmanager.k8s.io,orders.certmanager.k8s.io,backendconfigs.cloud.google.com,leases.coordination.k8s.io,daemonsets.extensions,deployments.extensions,ingresses.extensions,networkpolicies.extensions,replicasets.extensions,managedcertificates.networking.gke.io,ingresses.networking.k8s.io,networkpolicies.networking.k8s.io,updateinfos.nodemanagement.gke.io,poddisruptionbudgets.policy,rolebindings.rbac.authorization.k8s.io,roles.rbac.authorization.k8s.io,scalingpolicies.scalingpolicy.kope.io --all -n test"
              # "kubectl delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all -n test"]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}