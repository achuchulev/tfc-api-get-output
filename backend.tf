terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "<ORGANIZATION>"

    workspaces {
      name = "<WORKSPACE>"
    }
  }
}
