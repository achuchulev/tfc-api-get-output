terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "atanasc-2"

    workspaces {
      name = "tfc-api-get-output"
    }
  }
}
