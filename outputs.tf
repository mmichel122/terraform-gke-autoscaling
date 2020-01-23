output "network_vpc_uri" {
  value = "${module.network.network_vpc_uri}"
}

output "endpoint" {
  value = "${module.cluster.endpoint}"
}
