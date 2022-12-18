resource "aws_s3_bucket" "cicd-artifact-tg" {
    bucket = "cicd-artifact-tg-11am"
    acl = "private"
}