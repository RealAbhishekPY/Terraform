Setting up an EKS (Elastic Kubernetes Service) cluster using Terraform involves several steps. Here's a comprehensive example to guide you through the process:

### Prerequisites
Make sure you have the following installed:
- AWS CLI
- Terraform
- kubectl
- AWS IAM Authenticator

### Step 1: Configure AWS Credentials
First, configure AWS CLI with your access keys:
```sh
aws configure
```

### Step 2: Create a VPC
Create a file named `vpc.tf` to define the network setup:
```hcl
data "aws_availability_zones" "available" {}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_subnet" {
  count = 2
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = cidrsubnet(aws_vpc.example_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "example-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

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

resource "aws_route_table_association" "example_route_table_association" {
  count = 2
  subnet_id = element(aws_subnet.example_subnet.*.id, count.index)
  route_table_id = aws_route_table.example_route_table.id
}
```

### Step 3: Create Security Groups
Create a file named `security_groups.tf`:
```hcl
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}
```

### Step 4: Create an EKS Cluster
Create a file named `eks_cluster.tf`:
```hcl
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "example-cluster"
  cluster_version = "1.21"
  subnets         = aws_subnet.example_subnet[*].id
  vpc_id          = aws_vpc.example_vpc.id

  worker_groups = [
    {
      instance_type = "t3.medium"
      asg_max_size  = 3
      asg_min_size  = 1
      key_name      = "your-key-name"
    }
  ]

  tags = {
    Name = "example-eks-cluster"
  }
}
```

### Step 5: Apply the Configuration
Initialize and apply the Terraform configuration:
```sh
terraform init
terraform apply
```

### Step 6: Configure kubectl
Configure `kubectl` to use the new EKS cluster:
```sh
aws eks --region us-west-2 update-kubeconfig --name example-cluster
```

This setup will create an EKS cluster with the necessary VPC, subnets, security groups, and worker nodes.
