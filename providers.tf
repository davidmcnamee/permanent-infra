
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
    external = {
      source = "hashicorp/external"
      version = "2.1.0"
    }
    acme = {
      source = "vancluever/acme"
      version = "~> 2.0"
    }
  }
  # backend resources are declared below. If provisioning from scratch, comment out
  # this backend section, and after applying run `terraform init` again to copy state.
  backend "s3" {
     bucket = "permanent-infra-backend-state"
     key = "terraform/backend/terraform_aws.tfstate"
     region = "us-east-1"
     dynamodb_table = "permanent-infra-backend-locking"
     encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "buoyant-insight-339103"
  region = "us-central1"
}

resource "google_project_service" "compute_service" {
  service = "compute.googleapis.com"
}
resource "aws_s3_bucket" "backend_state" {
  bucket = "permanent-infra-backend-state"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "backend_locking" {
  name = "permanent-infra-backend-locking"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
  }
}
