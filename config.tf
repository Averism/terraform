terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "averism"

    workspaces {
      name = "terraform"
    }
  }
}
