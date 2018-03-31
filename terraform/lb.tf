resource "google_compute_instance_group" "reddit-app-group" {
  name        = "reddit-app-group"
  description = "GCP Instance Group for Load Balancing"
  instances   = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "reddit-app-port"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_http_health_check" "reddit-app-health-check" {
  name               = "reddit-app-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = "9292"
}

resource "google_compute_backend_service" "reddit-app-backend" {
  name        = "reddit-app-backend"
  port_name   = "reddit-app-port"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.reddit-app-group.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-app-health-check.self_link}"]
}

resource "google_compute_url_map" "reddit-app-map" {
  name            = "reddit-app-map"
  description     = "reddit-app-map"
  default_service = "${google_compute_backend_service.reddit-app-backend.self_link}"
}

resource "google_compute_target_http_proxy" "reddit-app-proxy" {
  name        = "reddit-app-proxy"
  description = "Reddit app http proxy"
  url_map     = "${google_compute_url_map.reddit-app-map.self_link}"
}

resource "google_compute_global_forwarding_rule" "reddit-app-forwarding-rule" {
  name       = "reddit-app-forwarding-rule"
  target     = "${google_compute_target_http_proxy.reddit-app-proxy.self_link}"
  port_range = "80"
}
