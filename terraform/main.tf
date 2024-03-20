terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.27"
    }
  }
  required_version = ">=0.41.9"

  backend "s3" {
    bucket = "terraformcibucket"         # bucket name
    key    = "terraformcibucket.tfstate" # path/to/your/terraform.tfstate
    region = "us-east-1"                 # your-region
  }
}

provider "aws" {
  region = "us-east-1"
}

