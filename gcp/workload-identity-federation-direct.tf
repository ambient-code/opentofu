# OpenTofu configuration for Direct Workload Identity Federation
# This creates a Workload Identity Pool and Provider to authenticate
# GitHub Actions to Google Cloud without service account keys.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

# Create the Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "github"
  display_name              = "GitHub Actions Pool"
}

# Create the Workload Identity Provider
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "ambient-code-github-actions"
  display_name                       = "ambient-code GitHub Actions"

  attribute_condition = "assertion.repository in ['ambient-code/platform', 'ambient-code/terraform']"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Grant Vertex AI User role to the ambient-code/platform repository.
# This applies to any branch since we scope by repository, not by ref.
resource "google_project_iam_member" "github_vertex_ai_access" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/ambient-code/platform"
}

# Outputs
output "workload_identity_pool_id" {
  description = "The ID of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github_pool.name
}

output "workload_identity_provider_name" {
  description = "The full resource name of the Workload Identity Provider (use this in GitHub Actions)"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}
