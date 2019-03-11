provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}
provider "vault" {
  address = "http://127.0.0.1:8200"
  token = "${var.vault_token}"
}
