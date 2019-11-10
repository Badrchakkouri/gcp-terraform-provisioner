resource "google_compute_network" "gcp_net" {
  name = "gcpnet"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gcp_sub" {
  ip_cidr_range = "10.0.0.0/20"
  name = "gcpsub"
  network = google_compute_network.gcp_net.self_link
}

resource "google_compute_address" "gcp_ip" {
  name = "gcpip"
  address_type = "EXTERNAL"
  region = "europe-west1"
}

resource "google_compute_firewall" "gcp_fw" {
  name = "gcpfw"
  network = google_compute_network.gcp_net.self_link
  allow {
    protocol = "TCP"
    ports = [80,22,443]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "gcp_vm" {
  machine_type = "f1-micro"
  name = "gcpvm"
  zone = "europe-west1-b"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.gcp_sub.self_link
    access_config {
      nat_ip = google_compute_address.gcp_ip.address
    }
  }

  //metadata = {
  // startup_script = file("./user_data.sh")
  //}

  //metadata_startup_script = file("./user_data.sh")

  service_account {
    scopes = [
      "userinfo-email",
      "compute-ro",
      "storage-ro"]
  }

  provisioner "remote-exec" {
    script = "./user_data.sh"

    connection {
      type        = "ssh"
      host        = google_compute_address.gcp_ip.address
      user        = "badr_chakkouri"
      private_key = file("./gcpkey.pem")
      //agent = true


    }
  }


}





