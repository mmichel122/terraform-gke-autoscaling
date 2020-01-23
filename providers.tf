provider "google" {
  credentials = file("/Users/MMR12/Secrets/terraform-sa-kube-demo.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file("/Users/MMR12/Secrets/terraform-sa-kube-demo.json")
  project     = var.project_id
  region      = var.region
}

/***
terraform {
  backend "remote" {
    organization = "modus-demo"
    workspaces {
      name = "aws-vpc-qa-eu-west"
    }
  }
}
***/
