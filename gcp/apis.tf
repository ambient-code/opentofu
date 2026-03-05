# GCP API Services
#
# Non-Owner principals can only call APIs that we explicitly enable.
#
# To list what is currently enabled, run:
#   gcloud services list --enabled --project=ambient-code-platform

# Required for Vertex AI
resource "google_project_service" "aiplatform" {
  project            = var.project_id
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

## Requirements for non-Owner principals to apply OpenTofu configurations:

# Required for managing google_project_iam_member
resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# Required for managing Workload Identity Federation settings
resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}
