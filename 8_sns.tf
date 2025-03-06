terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"  # Specifies the AWS provider version
    }
  }

  required_version = ">= 1.2.0"  # Specifies the required Terraform version
}

provider "aws" {
  region  = "us-west-2"  # Specifies the AWS region
  profile = "new.profile.name"  # Change this to your AWS profile name
}

# Create an SNS topic
resource "aws_sns_topic" "example_topic" {
  name = "example-topic"  # Change this to your desired topic name

  tags = {
    Name = "example-topic"
  }
}
