terraform {
    backend "s3" {
        bucket = "terraform-11am-backend"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}