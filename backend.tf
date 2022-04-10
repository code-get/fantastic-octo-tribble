
terraform {
  required_version = ">= 1.1"
  backend "s3" {
    profile = "default"
    region  = "ca-central-1"
    key     = "mongodb/terraform.tfstate"
    bucket  = "code-get"
  }
}

