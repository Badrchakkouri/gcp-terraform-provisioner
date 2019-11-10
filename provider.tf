//all the infor needed for connection to GCP is within the json file I have generated for my account from the GCP console
// the below inputs are the required ones.
provider "google" {
  credentials = file("./GCP-account.json")
  project     = var.my-gcp.project
  region      = var.my-gcp.project
}

terraform {
  backend "local" {
    path = "/share/terraform.tfstate"
  }
}

