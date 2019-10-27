provider "google" {
  credentials = file("./GCP-account.json")
  project = "quantum-talent-248210"
  region = "europe-west1"
}

