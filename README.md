# ambient-code-opentofu

[OpenTofu](https://opentofu.org/) configurations for the `ambient-code-platform` GCP project.

## What this manages

- **Workload Identity Federation** - GitHub Actions in `ambient-code/platform`
  authenticate to GCP without service account keys
- **GCP API enablement** - Vertex AI and supporting APIs
- **IAM bindings** - `roles/aiplatform.user` for CI workloads
- **CI/CD** - GitHub Actions workflow to validate, plan, and apply changes

## State backend

State is stored in a GCS bucket (`ambient-code-platform-tfstate`). You must
have access to this bucket to run `tofu init`.

The bucket should have:
- **Uniform bucket-level access** enabled (no per-object ACLs)
- **Object versioning** enabled (allows state recovery)
- **Restricted IAM** — only project administrators and the CI identity

## CI/CD

A GitHub Actions workflow runs on every push:

- **validate** — runs `tofu validate` on all branches
- **plan** — runs `tofu plan` on non-main branches
- **apply** — runs `tofu apply -auto-approve` on main

The workflow authenticates to GCP via Direct Workload Identity Federation
(no service account keys).

## Local usage

```
cd gcp
tofu init
tofu plan
tofu apply
```
