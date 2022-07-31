terraform {
    backend "s3" {
        bucket = "terraform-state-tg"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-2"
        access_key = "AKIAZBM4KLN6QNJ2LLNZ"
        secret_key = "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"
    }
}

provider "aws" {
    region = "us-east-1"
}