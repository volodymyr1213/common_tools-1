terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">=1.11"
  region  = "${var.aws_region}"
}
