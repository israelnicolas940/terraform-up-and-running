# Chapter 2: Getting Started with Terraform

## Overview
This chapter introduces the basics of Terraform by deploying a highly available web server cluster on AWS using Auto Scaling Groups behind an Application Load Balancer.

## What This Code Does
- Deploys a cluster of web servers using AWS Auto Scaling Group (2-10 instances)
- Sets up an Application Load Balancer to distribute traffic across instances
- Configures security groups for both the instances and load balancer
- Uses data sources to retrieve the default VPC and subnets
- Serves a simple "Hello, World" page on configurable ports
- Implements health checks to ensure instance availability

## Architecture

```
Internet
    ↓
Application Load Balancer (port 80)
    ↓
Security Group (ALB)
    ↓
Target Group
    ↓
Auto Scaling Group (2-10 instances)
    ↓
EC2 Instances (t3.micro, port 8080)
    ↓
Security Group (Instance)
```

## Key Differences from the Book's Implementation

### 1. **AWS Launch Template vs Launch Configuration**
- **Book's approach**: Uses deprecated `aws_launch_configuration`
- **My implementation**: Uses modern `aws_launch_template` with `name_prefix` for better rolling updates
- **Why**: Launch configurations are legacy; launch templates offer more features and AWS recommends them
- **Code difference**:
```hcl
# Book's version
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0fb653ca2d3203ac1"
  instance_type   = "t2.micro"
  # ...
}

# My version
resource "aws_launch_template" "example" {
  name_prefix   = "example-lt-"
  image_id      = "ami-0c398cb65a93047f2"
  instance_type = "t3.micro"
  # ...
}
```

### 2. **Modern Security Group Rules**
- **Book's approach**: Uses inline `ingress` and `egress` blocks within `aws_security_group`
- **My implementation**: Uses standalone `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` resources for the ALB security group
- **Why**: AWS recommends using separate rule resources for better flexibility and to avoid conflicts
- **Code difference**:
```hcl
# Book's version
resource "aws_security_group" "alb" {
  name = var.alb_security_group_name
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# My version
resource "aws_security_group" "alb" {
  name   = "terraform-example-alb"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = var.lb_port
  to_port           = var.lb_port
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
```

### 3. **Enhanced Instance Security**
- **Book's approach**: Allows instance traffic from anywhere (`cidr_blocks = ["0.0.0.0/0"]`)
- **My implementation**: Restricts instance ingress to only the ALB security group (`security_groups = [aws_security_group.alb.id]`)
- **Why**: Better security posture - instances should only accept traffic from the load balancer
- **Code difference**:
```hcl
# Book's version
resource "aws_security_group" "instance" {
  name = var.instance_security_group_name
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world!
  }
}

# My version
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]  # Only from ALB!
  }
  # ... explicit egress rules
}
```

### 4. **Explicit Egress Rules for Instances**
- **Book's approach**: No explicit egress rules (relies on default)
- **My implementation**: Explicitly defines egress rules allowing all outbound traffic
- **Why**: Makes the configuration more explicit and portable

### 5. **Variable Organization**
- **Book's approach**: Defines four variables including names for security groups and ALB
```hcl
variable "alb_name" { ... }
variable "instance_security_group_name" { ... }
variable "alb_security_group_name" { ... }
```
- **My implementation**: Simplified to two essential variables (`server_port` and `lb_port`)
- **Why**: Reduces unnecessary configuration; names can be hardcoded for learning examples

### 6. **Resource Naming**
- **Book's approach**: Uses variables for resource names
- **My implementation**: Uses descriptive hardcoded names and `name_prefix` where appropriate
- **Why**: Clearer for learning purposes; `name_prefix` allows AWS to generate unique names

### 7. **Load Balancer Configuration**
- **Book's approach**: Uses `var.alb_name` for both ALB and target group names
- **My implementation**: Uses `name_prefix = "ex-tg-"` for target group to avoid naming conflicts
- **Why**: Target groups need unique names; prefix allows automatic unique name generation

### 8. **AMI Selection**
- **Book's approach**: Uses `ami-0fb653ca2d3203ac1` (Ubuntu 20.04 for us-east-2)
- **My implementation**: Uses `ami-0c398cb65a93047f2` (Ubuntu 22.04 for us-east-1)
- **Why**: Different AMI required for different region; using newer Ubuntu LTS version

### 9. **Instance Type**
- **Book's approach**: Uses `t2.micro`
- **My implementation**: Uses `t3.micro`
- **Why**: T3 instances are newer generation and offer better price-performance

### 10. **Base64 Encoding for User Data**
- **Book's approach**: Passes user data as plain text
- **My implementation**: Uses `base64encode()` function
- **Why**: Launch templates require base64-encoded user data

## Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `server_port` | Port for the web server | `number` | `8080` |
| `lb_port` | Port for the load balancer | `number` | `80` |

## Outputs

| Output | Description |
|--------|-------------|
| `alb_dns_name` | The DNS name of the Application Load Balancer |

## Usage

### Deploy the Infrastructure

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply

# Note the ALB DNS name from the output
```

### Test the Deployment

```bash
# Access the web server using the ALB DNS name
curl http://<alb_dns_name_output>

# You should see: Hello, World

# Test load balancing by making multiple requests
for i in {1..100}; do curl http://<alb_dns_name_output>; done
```

### Clean Up

```bash
# Destroy all resources
terraform destroy
```

## Key Terraform Concepts Demonstrated

1. **Resources**: Creating and managing AWS infrastructure
2. **Data Sources**: Querying existing infrastructure (VPC, subnets)
3. **Variables**: Making configuration reusable and flexible
4. **Outputs**: Exposing important values after deployment
5. **Interpolation**: Referencing variables and resource attributes
6. **Dependencies**: Terraform automatically handles resource creation order
