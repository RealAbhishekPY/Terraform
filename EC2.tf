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
  profile = "new.profile.name"  # profile name 
}

resource "aws_instance" "example_server" {
  ami           = "ami-04e914639d0cca79a"  # Specifies the Amazon Machine Image (AMI) ID
  instance_type = "t2.micro"  # Specifies the instance type

  tags = {
    Name = "NewTagName"  #tag name
  }
}
