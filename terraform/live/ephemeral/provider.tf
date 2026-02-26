terraform {
  backend "s3" {
    bucket         = "mini-gallery-app-states"
    key            = "ephemeral/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "ephemeral-mini-gallery-app-terraform-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18"
    }
  }

  required_version = ">= 1.6.0, < 2.0.0"
}

provider "aws" {
  region = var.region
}