resource "google_container_cluster" "primary" {
  name       = var.cluster_name
  location   = var.location
  network    = var.network_vpc
  subnetwork = var.subnetwork

  vertical_pod_autoscaling {
    enabled = true
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.second_net_pods
    services_secondary_range_name = var.second_net_services
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.0.16/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "35.241.161.8/32"
      display_name = "Cloud Shell"
    }
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}


resource "google_container_node_pool" "system_nodes" {
  name       = "system-nodes"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.nodes_size
    disk_type    = "pd-standard"
    service_account = var.service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    tags            = ["kubernetes-system"]
    labels = {
      pool-type = "system"
    }
  }
}


resource "google_container_node_pool" "worker_nodes" {
  name       = "worker-nodes"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 0

  autoscaling {
    min_node_count = var.autoscale_min_nodes
    max_node_count = var.autoscale_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.nodes_size
    disk_type    = "pd-standard"
    service_account = var.service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    tags            = ["kubernetes-worker"]
    labels = {
      pool-type = "worker"
    }
    taint {
      key = "scripts"
      value = "true"
      effect = "NO_SCHEDULE"
    }
  }
}
