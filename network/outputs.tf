output "network_vpc_uri" {
  value = "${google_compute_network.gke_network.self_link}"
}

output "subnetwork_link" {
  value = "${google_compute_subnetwork.europe.0.name}"
}

output "vpc_name" {
  value = "${google_compute_network.gke_network.name}"
}

output "second_net_pods" {
  value = "${google_compute_subnetwork.europe.0.secondary_ip_range.0.range_name}"
}

output "second_net_services" {
  value = "${google_compute_subnetwork.europe.0.secondary_ip_range.1.range_name}"
}
