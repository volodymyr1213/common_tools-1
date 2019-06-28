terraform {
  backend "gcs" {
    bucket  = "fuchicorp-bucket"
    prefix  = "tools/common_tools"
    project = "fuchicorp-project"
  }
}
