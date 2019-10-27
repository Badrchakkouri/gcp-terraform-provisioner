//showing the URL to access the webpage after terraform ends its work
output "output" {
  value = "http://${google_compute_address.gcp_ip.address}"
}