# CLAUDE.md

## Terminology

Use "OpenTofu" instead of "Terraform" in all documents and commit messages.

## Cloud Provider Authentication

For cloud connections, prefer *Direct* Workload Identity Federation over service accounts for simplicity.

Use separate workload identity pools per identity source (GitHub, GitLab.com, etc.) for security isolation.

## Code Style

Prefer simplicity and clarity for newcomers to this repo. All teammates need to be able to read the code top-to-bottom, minimizing cognitive load.

Hardcode static values instead of adding variables. Values that never change don't need indirection.
