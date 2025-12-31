terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }

  backend "s3" {
    bucket = "tf-stateconflict-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

