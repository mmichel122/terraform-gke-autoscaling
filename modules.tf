module "network" {
  source       = "./network"
  project_name = var.project_name
  cidr_block   = var.cidr_block
  network_name = var.network_name
  #ssh_source_ips       = var.ssh_source_ips
  second_cidr_pods     = var.second_cidr_pods
  second_cidr_services = var.second_cidr_services
  subnets_count        = var.subnets_count
  region               = var.region
}

module "cluster" {
  source              = "./cluster"
  project_name        = var.project_name
  cluster_name        = var.cluster_name
  network_vpc         = module.network.network_vpc_uri
  subnetwork          = module.network.subnetwork_link
  location            = var.location
  nodes_size          = var.nodes_size
  autoscale_min_nodes = var.autoscale_min_nodes
  autoscale_max_nodes = var.autoscale_max_nodes
  second_net_pods     = module.network.second_net_pods
  second_net_services = module.network.second_net_services
  service_account     = module.service_account.email
}

module "service_account" {
  source      = "./service-account"
  name        = var.cluster_name
  project     = var.project_name
}
