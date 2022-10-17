resource "google_compute_backend_bucket" "bucket_backend" {
  name        = "${var.project-name}-bucket-backend"
  bucket_name = google_storage_bucket.website-frontend.name
  enable_cdn  = true
  project     = var.project_id
}

resource "google_compute_global_forwarding_rule" "ipv4_https" {
  ip_address            = google_compute_global_address.default.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  name                  = "${var.project-name}-ipv4-https"
  port_range            = "443"
  project               = var.project_id
  target                = google_compute_target_https_proxy.https_proxy.self_link

  depends_on = []
}


resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.project-name}-https-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = [for domain in var.domains : google_compute_managed_ssl_certificate.certificate[domain].self_link]
}

resource "google_compute_url_map" "default" {
  name            = "${var.project-name}-url-map"
  default_service = google_compute_backend_bucket.bucket_backend.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_managed_ssl_certificate" "certificate" {
  for_each = toset(var.domains)

  name    = replace(substr(replace("${var.project-name}-${each.key}", ".", "--"), 0, 63), "/([a-z0-9-]+[^-])(-*)/", "$1")
  project = var.project_id

  managed {
    // NB: even if this is a list, we can specify at most 1 domain here (Google restrictions)
    domains = ["${each.key}."]
  }

  lifecycle {
    create_before_destroy = true
  }
}
