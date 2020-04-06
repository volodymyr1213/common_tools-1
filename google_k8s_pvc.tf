resource "kubernetes_storage_class" "fuchicorp_storage_class" {
  metadata {
    name = "fuchicorp-storage-class"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Retain"
  parameters = {
    type = "pd-standard"
    # type = "pd-fast"
  }
  # lifecycle {
  #  prevent_destroy = "true"
  # }
  //mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
}


resource "kubernetes_persistent_volume_claim" "fuchicorp_pv_claim" {
  metadata {
    name = "fuchicorp-pv-claim"
    namespace = "tools"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "15Gi"
      }
    }
    storage_class_name = "${kubernetes_storage_class.fuchicorp_storage_class.metadata.0.name}"
  }
  lifecycle {
     prevent_destroy = "true"
  }
}
