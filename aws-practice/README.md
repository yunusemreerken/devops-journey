# AWS LocalStack Demo — S3

Local AWS development environment using Docker + LocalStack.

## What this project shows
- Running AWS S3 locally with LocalStack
- Basic AWS CLI usage without real cloud

## Requirements
- Docker
- AWS CLI
- LocalStack

## Usage
```bash
docker run --rm -d -p 4566:4566 localstack/localstack
aws --endpoint-url=http://localhost:4566 s3 mb s3://my-test-bucket
aws --endpoint-url=http://localhost:4566 s3 ls
```

## Screenshot
[terminal screenshot here]