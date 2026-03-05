# Plan: GitHub Actions CI/CD for this repo

Automate OpenTofu validate/plan/apply with GitHub Actions.

## Pipeline stages

1. **validate** (all branches and PRs) - `tofu init -backend=false && tofu validate`
   - No GCP authentication needed
2. **plan** (PRs only) - `tofu plan`
   - Authenticate to GCP via workload identity federation
   - Post plan output as a PR comment
3. **apply** (main branch only) - `tofu apply -auto-approve`
   - Runs after merge to main

## Authentication

GitHub Actions authenticates to GCP using the workload identity federation
pool defined in this repo. This is a chicken-and-egg: the first apply must
be done locally, then CI manages itself going forward.

The CI job also needs access to the GCS state bucket.

## Prerequisites before implementing

- The workload identity federation resources from this repo must be applied
- The GCS state bucket must exist
- Grant the CI identity permission to read/write the GCS state bucket
- Grant the CI identity `roles/iam.workloadIdentityPoolAdmin` and
  `roles/iam.securityAdmin` so it can manage WIF and IAM resources

## Implementation notes

- Use `google-github-actions/auth` action for workload identity auth
- Pin OpenTofu version in the workflow
- Use `hashicorp/setup-terraform` or install OpenTofu directly
