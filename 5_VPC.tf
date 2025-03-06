Here's an example of Terraform code to create a Virtual Private Cloud (VPC) in AWS, including subnets, route tables, and an internet gateway:

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

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block           = "10.0.0.0/16"  # Specifies the CIDR block for the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"  # Specifies the CIDR block for the subnet
  availability_zone = "us-west-2a"  # Specifies the availability zone

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.2.0/24"  # Specifies the CIDR block for the subnet
  availability_zone = "us-west-2b"  # Specifies the availability zone

  tags = {
    Name = "public-subnet-2"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

# Create a route table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-route-table"
  }
}

# Associate the route table with the public subnets
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.example_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.example_route_table.id
}
```

### Comments:
- **AWS Provider Version**: Specifies the version of the AWS provider to use.
- **Terraform Version**: Specifies the minimum required version of Terraform.
- **AWS Region**: Specifies the AWS region where resources will be created.
- **AWS Profile**: Specifies the AWS profile to use for authentication.
- **VPC**: Creates a Virtual Private Cloud (VPC) with a specified CIDR block.
- **Public Subnets**: Creates two public subnets within the VPC, each in a different availability zone.
- **Internet Gateway**: Creates an internet gateway and attaches it to the VPC.
- **Route Table**: Creates a route table with a default route to the internet gateway.
- **Route Table Associations**: Associates the route table with the public subnets.

This configuration will create a VPC with public subnets, an internet gateway, and a route table. 
