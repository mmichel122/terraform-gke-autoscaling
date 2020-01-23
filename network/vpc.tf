
resource "google_compute_network" "gke_network" {
  name                    = var.network_name
  description             = "VPC That hosts the GKE Cluster"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "europe" {
  count                    = var.subnets_count
  name                     = "gke-net"
  ip_cidr_range            = cidrsubnet(var.cidr_block, 8, count.index + 1)
  region                   = var.region
  network                  = google_compute_network.gke_network.self_link
  private_ip_google_access = true

  secondary_ip_range { 
    range_name = "pods-net" 
    ip_cidr_range = cidrsubnet(var.second_cidr_pods, 8, count.index + 1)
  }

  secondary_ip_range { 
    range_name = "services-net" 
    ip_cidr_range = cidrsubnet(var.second_cidr_services, 8, count.index + 1)
  }
}

/***
resource "google_compute_firewall" "gke_network" {
  name    = "gke-wordpress"
  network = "${google_compute_network.gke_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "30000"]
  }

  source_ranges = var.ssh_source_ips
}
***/