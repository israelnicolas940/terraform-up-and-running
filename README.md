# Terraform Up and Running - Learning Repository

## Overview
This repository tracks my journey learning Infrastructure as Code with Terraform by working through "Terraform Up and Running" by Yevgeniy Brikman. Each chapter's examples are implemented with my own variations, improvements, and modernizations based on current AWS and Terraform best practices.

## Purpose
- 📚 Document my learning progress through the book
- 💻 Build hands-on experience with Terraform
- 🔄 Modernize book examples using current best practices
- 📝 Track differences between my implementations and the original code
- 🎯 Create a reference for future Terraform projects

## Repository Structure
```
.
├── chapter-02/        
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── README.md
├── chapter-03/           
├── chapter-04/         
└── README.md      
```

## Chapters

### Chapter 2: Getting Started with Terraform
**Status**: ✅ Complete

**What I Built**: A highly available web server cluster using Auto Scaling Groups behind an Application Load Balancer

**Key Learnings**:
- Auto Scaling Groups and Launch Templates
- Application Load Balancers and target groups
- Security group configuration
- Data sources for querying existing infrastructure
- Variables and outputs

**My Improvements Over the Book**:
- Used modern `aws_launch_template` instead of deprecated `aws_launch_configuration`
- Implemented stricter security (instances only accept traffic from ALB)
- Used newer security group rule resources
- Upgraded to T3 instances for better performance

[View Chapter 2 Details →](./chapter-02/README.md)

---

### Chapter 3: [Coming Soon]
More to come as I progress through the book!

## General Differences from the Book

## General Differences from the Book

Throughout this repository, I've made several consistent improvements and modernizations:

### Security Enhancements
- Stricter security group rules (principle of least privilege)
- Explicit egress rules instead of relying on defaults
- Instance-level restrictions to only accept traffic from load balancers

### Modern Terraform Practices
- Using current resource types (e.g., launch templates vs launch configurations)
- Leveraging `name_prefix` for automatic unique naming
- Explicit `base64encode()` for user data in launch templates
- Standalone security group rule resources

### AWS Best Practices
- Updated instance types (T3 family vs T2)
- Region-appropriate AMI selection
- Modern Terraform provider features

### Code Organization
- Simplified variable structures (fewer unnecessary variables)
- Clear, descriptive resource naming
- Well-documented outputs

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS Account with appropriate credentials configured
- Basic understanding of AWS services (EC2, VPC, ALB)

## Getting Started

1. Clone this repository:
```bash
git clone https://github.com/israelnicolas940/terraform-up-and-running
cd terraform-up-and-running
```

2. Navigate to a specific chapter:
```bash
cd chapter-02
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the planned changes:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

6. Clean up resources when done:
```bash
terraform destroy
```

## Learning Approach

For each chapter, I:
1. ✅ Read the chapter thoroughly
2. ✅ Implement the examples from the book
3. ✅ Research and apply modern alternatives where applicable
4. ✅ Document differences and learning points
5. ✅ Test the infrastructure
6. ✅ Destroy resources to avoid costs

## Cost Considerations

⚠️ **Important**: Running these examples will incur AWS charges. Remember to:
- Destroy resources after testing (`terraform destroy`)
- Monitor your AWS billing dashboard
- Set up billing alerts
- Most examples use free-tier eligible resources, but check current pricing

## Notes

- All code is tested in `us-east-1` unless otherwise specified
- I'm using newer resource types and practices than the book where it makes sense
- Each chapter has its own detailed README explaining specific implementations
- This is a learning repository - not production-ready code

## Resources

- 📖 Book: [Terraform Up and Running](https://www.terraformupandrunning.com/)
- 📚 [Terraform Documentation](https://www.terraform.io/docs)
- 🔧 [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- 💡 [Terraform Best Practices](https://www.terraform-best-practices.com/)

## Progress Tracking

- [x] Chapter 1: Why Terraform
- [x] Chapter 2: Getting Started with Terraform
- [ ] Chapter 3: How to Manage Terraform State
- [ ] Chapter 4: How to Create Reusable Infrastructure with Terraform Modules
- [ ] Chapter 5: Terraform Tips and Tricks
- [ ] Chapter 6: Production-Grade Terraform Code
- [ ] Chapter 7: How to Test Terraform Code
- [ ] Chapter 8: How to Use Terraform as a Team
