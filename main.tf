//First I define the VPC for the project
resource "google_compute_network" "gcp_net" {
  name                    = "gcpnet"
  auto_create_subnetworks = false
}

//I create a subnet within the VPC
resource "google_compute_subnetwork" "gcp_sub" {
  ip_cidr_range = var.my-gcp.cidr
  name          = "gcpsub"
  network       = google_compute_network.gcp_net.self_link
}

//I reserve a public IP to use for the instance. I could skip this if I entended to use an ephemeral IP instead
resource "google_compute_address" "gcp_ip" {
  name         = "gcpip"
  address_type = "EXTERNAL"
  region       = var.my-gcp.region
}

//I create a firewall and link it the the VPC. Rules to allow are ssh to access the instance and obviously http to access the web page
resource "google_compute_firewall" "gcp_fw" {
  name    = "gcpfw"
  network = google_compute_network.gcp_net.self_link
  allow {
    protocol = "TCP"
    ports    = [22,80]
  }
  source_ranges = ["0.0.0.0/0"]
}

//Then I create the a contos-7 VM
resource "google_compute_instance" "gcp_vm" {
  machine_type = var.my-vm.machine_type
  name         = "gcpvm"
  zone         = var.my-gcp.zone
  boot_disk {
    initialize_params {
      image = var.my-vm.image
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.gcp_sub.self_link //a NIC within the subnet I created above
    access_config {
      nat_ip = google_compute_address.gcp_ip.address //I nat the NIC with the reserved public IP address
    }
  }

  service_account {
    scopes = [
      "userinfo-email",
      "compute-ro",
    "storage-ro"]
  }

  /*
  Now time for the Webserver installation and index.html customizing
  2 ways to do this
  1st method: using the metadata_startup_script parameter which runs a script at the VM build. I won't be using
  this method here so I'll leave it below commented
  */

  //metadata_startup_script = file("./user_data.sh")

  /*
  2nd method is using terrafom's provisioner which will enable terraform to ssh the VM and run our script in it after
  the build.
  The ssh connection ssh-key based. For that I have generated a key pair and added the public key to GCP compute engine.
  I will first copy the script user_data.sh to the VM then run it.
  */

  //moving the file to a /tmp in the VM with terraform file provisioner
  provisioner "file" {

    source      = "./user_data.sh"
    destination = "/tmp/user_data.sh"

    // here goes the connection info
    connection {
      type        = "ssh"
      host        = google_compute_address.gcp_ip.address // public IP address of the VM
      user        = var.my-vm.user                        // the account that google creates in the VM this is something we can check in the compute engine
      private_key = file("./gcpkey.pem")                  // the location of the private key I generated earlier
    }
  }

  //executing the script in the VM with the remote-exec provisioner
  provisioner "remote-exec" {
    /*
    one thing to pay attention to if the shell script was written in windows environment, it just won't run in the VM.
    I had to convert the script file to unix file format for it to work. This can be done via Dos2Unix tool or simply
    via vim or vi with the :set fileformat=unix after issuing ESC.
    */

    //running the script
    inline = [
      "sudo chmod +x /tmp/user_data.sh",
      "sudo /tmp/user_data.sh"
    ]

    //same connection info as above
    connection {
      type        = "ssh"
      host        = google_compute_address.gcp_ip.address
      user        = var.my-vm.user
      private_key = file("./gcpkey.pem")
    }

  }

}





