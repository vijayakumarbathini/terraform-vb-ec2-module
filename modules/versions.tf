terraform {

  backend "s3" {

    bucket = "terraform-remote-state-vbathini-lab"
    key    = "vbathini_lab/terraform.tfstate"
    region = "us-east-1"

  }

  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "vbathini_poc"

  #   workspaces {
  #     name = "CLI"
  #   }
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}