# IAM grants for GitHub Actions CI to run "tofu plan" and "tofu apply"
# on this repo (ambient-code/opentofu).

locals {
  ci_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/ambient-code/opentofu"
}

# Read and write OpenTofu state in the GCS backend bucket.
resource "google_storage_bucket_iam_member" "ci_state_bucket" {
  bucket = "ambient-code-platform-tfstate"
  role   = "roles/storage.admin"
  member = local.ci_principal
}

# Read the status of enabled GCP APIs during plan/apply.
resource "google_project_iam_member" "ci_service_usage_viewer" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageViewer"
  member  = local.ci_principal
}

# Manage Workload Identity Pool and Provider resources.
resource "google_project_iam_member" "ci_wif_admin" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityPoolAdmin"
  member  = local.ci_principal
}

# Manage IAM bindings, scoped to specific roles only.
# The condition prevents CI from granting itself (or others) broader
# permissions than intended.
resource "google_project_iam_member" "ci_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = local.ci_principal

  condition {
    title      = "limit_to_safe_roles"
    expression = "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['roles/aiplatform.user'])"
  }
}
