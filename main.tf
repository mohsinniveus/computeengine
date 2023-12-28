terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("/Users/apple/Documents/dev/googlecloud/tech-rnd-project-6df7d1f60e63.json")

  project = "tech-rnd-project"
  region  = "asia-south1"
  zone    = "asia-south1-a"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  # To keep the setup simple you can set the network_interface to default
  # For Advance network setup refer to Point-7 : Setup Network and Firewall for virtual machine
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

 metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Niveus Solutions Pvt Ltd</h1></body></html>' | sudo tee /var/www/html/index.html"

 // Apply the firewall rule to allow external IPs to access this instance
  tags = ["test-fw-allow-http","test-fw-allow-https"]

}

 # Enable port 90 to allow http traffic
resource "google_compute_firewall" "allow-http" {
  name = "test-fw-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http"]
}

# Enable port 443 to allow https traffic
resource "google_compute_firewall" "allow-https" {
  name = "test-fw-allow-https"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https"]
}