
resource "random_password" "gke_password" {
  length  = 16
  special = true
}
locals { gke_username = "davidmcnamee-gke-master" }
output "gke_username" { value = local.gke_username }
output "gke_password" {
  value = random_password.gke_password.result
  sensitive = true
}

# GKE cluster
resource "google_container_cluster" "cluster" {
  name                     = local.gke_username
  min_master_version = "1.19"
  location                 = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# Primary NodePool for cluster
resource "google_container_node_pool" "cluster_nodes" {
  name       = "${google_container_cluster.cluster.name}-node-pool"
  location   = "us-central1"
  node_locations = ["us-central1-a"]
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels       = { type = "cluster-node" }
    machine_type = "e2-medium"
  }
}

resource "google_compute_global_address" "external_ip" {
  name = "davidmcnamee-gke-static-ip"
}

output "gke_static_ip" {
  value = google_compute_global_address.external_ip.address
}
