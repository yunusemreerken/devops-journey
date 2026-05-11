![Terraform](https://img.shields.io/badge/Terraform-1.x-623CE4?logo=terraform)
![LocalStack](https://img.shields.io/badge/LocalStack-Compatible-1DB954)
![AWS](https://img.shields.io/badge/AWS-S3%20%7C%20IAM-FF9900?logo=amazon-aws)

# ☁️ AWS Infrastructure as Code — Terraform + LocalStack

> Real-world Terraform configurations for AWS services, tested locally with LocalStack before going live.
>

## Quick Start

```bash
# Start LocalStack
docker run -d -p 4566:4566 localstack/localstack

# Apply Terraform config
terraform init
terraform apply -var="env=dev"
```

**Expected output:**
```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```


## Resources Created

| Resource | Description | LocalStack Compatible |
|----------|-------------|----------------------|
| `aws_s3_bucket` | Main storage bucket | ✅ |
| `aws_iam_role` | App execution role | ✅ |
| `aws_iam_policy` | Least-privilege policy | ✅ |

## Project Structure

```
aws-practice/
├── main.tf          # Core resource definitions
├── variables.tf     # Input variables
├── outputs.tf       # Useful outputs (bucket ARN, role ARN)
└── README.md
```
