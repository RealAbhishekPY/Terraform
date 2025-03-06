Here's an example of Terraform code to create an SNS (Simple Notification Service) topic and an SQS (Simple Queue Service) queue, and to subscribe the SQS queue to the SNS topic:

### Step 1: Create SNS Topic
Create a file named `sns.tf`:
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

# Create an SNS topic
resource "aws_sns_topic" "example_topic" {
  name = "example-topic"  # Change this to your desired topic name

  tags = {
    Name = "example-topic"
  }
}
```

### Step 2: Create SQS Queue
Create a file named `sqs.tf`:
```hcl
# Create an SQS queue
resource "aws_sqs_queue" "example_queue" {
  name = "example-queue"  # Change this to your desired queue name

  tags = {
    Name = "example-queue"
  }
}
```

### Step 3: Subscribe SQS Queue to SNS Topic
Create a file named `sns_sqs_subscription.tf`:
```hcl
# Subscribe the SQS queue to the SNS topic
resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.example_queue.arn

  # Allow SNS to send messages to the SQS queue
  depends_on = [aws_sqs_queue_policy.example_queue_policy]
}

# Create a policy to allow SNS to send messages to the SQS queue
resource "aws_sqs_queue_policy" "example_queue_policy" {
  queue_url = aws_sqs_queue.example_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.example_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.example_topic.arn
          }
        }
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
- **SNS Topic**: Creates an SNS topic with the specified name.
- **SQS Queue**: Creates an SQS queue with the specified name.
- **SNS Subscription**: Subscribes the SQS queue to the SNS topic.
- **SQS Queue Policy**: Creates a policy to allow SNS to send messages to the SQS queue.

This configuration will create an SNS topic, an SQS queue, and subscribe the SQS queue to the SNS topic. 
