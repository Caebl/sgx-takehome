resource "google_container_cluster" "autopilot" {
  provider            = google-beta
  name                = "sgx-autopilot"
  location            = var.region
  enable_autopilot    = true
  deletion_protection = false
}