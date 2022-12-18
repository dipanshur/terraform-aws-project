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
    access_key = "AKIAQRVBO4Z6Q6VLL5F6"
    secret_key = "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"
}