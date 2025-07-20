terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
    random = {
      source = "hashicorp/random"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.12"
}

provider "google" {
  #credentials = file("gcp-credentials.json")
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}
