terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.3"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.ACCESS_KEY_ID
  secret_key = var.SECRET_ACCESS_KEY
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}