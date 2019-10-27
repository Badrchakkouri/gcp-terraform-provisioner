output "output" {
  value = "http://${google_compute_address.gcp_ip.address}"
}