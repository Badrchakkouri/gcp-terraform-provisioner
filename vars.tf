//defining my variables. I choose to go with type map just for fun
variable "my-gcp" {
  type = "map"
  default = {
    "project" = "quantum-talent-248210"
    "region"  = "europe-west1"
    "zone"    = "europe-west1-b"
    "cidr"  = "10.0.0.0/20"
  }
}

variable "my-vm" {
  type = "map"
  default = {
    "image"        = "centos-cloud/centos-7"
    "user"         = "badr_chakkouri"
    "machine_type" = "f1-micro"
  }
}



