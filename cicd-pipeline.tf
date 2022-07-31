resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan2"
  description   = "plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.2.2"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
        credential = var.docker_cred
        credential_provider = "SECRETS_MANAGER"
    }
    }

  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
  }
  }


 resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "apply stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.2.2"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
        credential = var.docker_cred
        credential_provider = "SECRETS_MANAGER"
    }
    }

  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
  } 

# Code Pipeline block -------------------------

  resource "aws_codepipeline" "cicd-pipeline" {
  name     = "tf-cicd"
  role_arn = aws_iam_role.tf-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.cicd-artifact-tg.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tf-code"]

      configuration = {
        ConnectionArn    = var.codestar_cred
        FullRepositoryId = "dipanshur/terraform-aws-project"
        BranchName       = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }



  stage {
    name = "Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts = ["tf-code"]

      configuration = {
        ProjectName = "tf-cicd-plan2"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts = ["tf-code"]

      configuration = {
        ProjectName = "tf-cicd-apply"
      }
    }
  }

}