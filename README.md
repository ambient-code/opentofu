# ambient-code-terraform

OpenTofu configurations for the `ambient-code-platform` GCP project.

## What this manages

- **Workload Identity Federation** - GitHub Actions in `ambient-code/platform`
  authenticate to GCP without service account keys
- **GCP API enablement** - Vertex AI and supporting APIs
- **IAM bindings** - `roles/aiplatform.user` for CI workloads

## Prerequisites

- [OpenTofu](https://opentofu.org/) installed
- GCP credentials: `gcloud auth application-default login`
- Access to the `ambient-code-platform` GCP project

## State backend

State is stored in a GCS bucket (`ambient-code-platform-tfstate`). You must
have access to this bucket to run `tofu init`.

## Usage

```
cd gcp
tofu init
tofu plan
tofu apply
```
