Here's an example of Terraform code to create an S3 bucket with bucket policies:

```hcl
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

# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name"  # Change this to your desired bucket name

  tags = {
    Name = "example-bucket"
  }
}

# Create a bucket policy
resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "${aws_s3_bucket.example_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}
```

### Comments:
- **AWS Provider Version**: Specifies the version of the AWS provider to use.
- **Terraform Version**: Specifies the minimum required version of Terraform.
- **AWS Region**: Specifies the AWS region where resources will be created.
- **AWS Profile**: Specifies the AWS profile to use for authentication.
- **S3 Bucket**: Creates an S3 bucket with the specified name.
- **Bucket Policy**: Creates a bucket policy that allows public read access to the objects in the bucket.

This configuration will create an S3 bucket with a bucket policy that allows public read access to the objects in the bucket.
