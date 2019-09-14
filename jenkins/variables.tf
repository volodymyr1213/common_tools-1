variable "s3_bucket" {}
variable "environment" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "s3_folder_project" {}
variable "s3_folder_type" {}

variable "jenkins" {
  type = "map"
}

variable "existing_pvc" {
  default = ""
}

variable "vet_tools_image" {
  default = "vet-docker.docker.artifactory.vet-tools.digitalecp.mcd.com/docker-build-tools-image"
}

variable "vet_tools_image_tag" {
  default = "master-latest"
}

# Variables for common tagging module
variable "tags" {
  type        = "map"
  description = "Tags to be passed into the common tagging Terraform module"
}

variable "newrelic_license" {
  default = ""
}
