# Partial HTTP load balancer redirects to HTTPS
resource "google_compute_url_map" "static_http" {
  name = "${var.project-name}-static-http-redirect"

  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_http_proxy" "static" {
  name    = "${var.project-name}-static-http-proxy"
  url_map = google_compute_url_map.static_http.id
}

resource "google_compute_global_forwarding_rule" "static_http" {
  name       = "${var.project-name}-static-forwarding-rule-http"
  target     = google_compute_target_http_proxy.static.id
  port_range = "80"
  ip_address = google_compute_global_address.default.id
}
