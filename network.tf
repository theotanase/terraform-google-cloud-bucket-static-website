resource "google_compute_network" "default" {
  name                    = var.project-name
  auto_create_subnetworks = true
  project                 = var.project_id

  lifecycle {
    create_before_destroy = true
  }
}

# reserved IP address
resource "google_compute_global_address" "default" {
  name    = "${var.project-name}-static-ip"
  project = var.project_id
}