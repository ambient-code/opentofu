terraform {
  backend "gcs" {
    bucket = "ambient-code-platform-tfstate"
    prefix = "gcp"
  }
}
