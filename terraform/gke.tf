data "google_compute_zones" "available" {
  region = var.region
}

resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.available.names
  result_count = 1
}

resource "google_container_cluster" "primary" {
  name     = "${var.name_prefix}-${var.environment}"
  location = random_shuffle.zone.result[0]

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.private_subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {} // Enables use of VPC-native routing

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    service_account = "terraform-sa@johnydev.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.name_prefix}-${var.environment}-nodepool"
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    service_account = "terraform-sa@johnydev.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    // Assign nodes to the private subnet
    tags = ["gke-node", "private-subnet"]
  }
}

