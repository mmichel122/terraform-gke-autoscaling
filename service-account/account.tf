resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = "sa-${var.name}-${random_string.suffix.result}"
  display_name = "Example GKE Cluster Service Account managed by Terraform"
}

locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.admin"
  ])
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}