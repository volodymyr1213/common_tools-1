terraform {
  backend "gcs" {
    bucket  = "fuchicorp"
    prefix  = "tools/common_tools"
    project = "fuchicorp-project"
  }
}
