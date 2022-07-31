terraform {
    backend "s3" {
        bucket = "terraform-state-tg"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-2"
        access_key = "AKIAZBM4KLN6WJFVJKQX"
        secret_key = "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"
    }
}

provider "aws" {
    region = "us-east-1"
}