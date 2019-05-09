 
 resource "kubernetes_namespace" "dev-namespace" {
  metadata {
    name = "dev-students" 
  }
}

resource "kubernetes_namespace" "qa-namespace" {
  metadata {
    name = "qa-students" 
  }
}

resource "kubernetes_namespace" "prod-namespace" {
  metadata {
    name = "prod-students" 
  }
} 