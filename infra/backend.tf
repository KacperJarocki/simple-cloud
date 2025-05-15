terraform {
  cloud {
    organization = "studio-bez-eksperckie"
    workspaces {
      name    = "simple-cloud-development"
      project = "simple-cloud"
    }
    hostname = "app.terraform.io"
  }
}
