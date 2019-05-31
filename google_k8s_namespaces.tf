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

## Create namespace for Dev, QA, Prod and Tools
resource "kubernetes_namespace" "service_tools" { metadata { name = "${var.namespace}"}}

resource "kubernetes_namespace" "qa" { metadata { name = "qa"}}

resource "kubernetes_namespace" "prod" { metadata { name = "prod"}}

resource "kubernetes_namespace" "test" { metadata { name = "test"}}

resource "kubernetes_namespace" "dev" { metadata { name = "dev"}}
