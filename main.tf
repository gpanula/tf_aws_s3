#terraform {
  # The configuration for this backend will be filled in by Terragrunt
#  backend "s3" {}
#}

provider "aws" {
  # region we are performing our work in
  region = "${var.region}"
}
