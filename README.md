# Cloud Networking Assignment

Terraform provisions the assignment topology in two Availability Zones:

- VPC `10.0.0.0/16`
- Public subnet `10.0.0.0/24` with an Internet Gateway route
- Private subnet `10.0.1.0/24` with a NAT Gateway route
- Public bastion and private EC2 instances
- SSH to the bastion allowed from anywhere on the internet; SSH to the private instance allowed only from the bastion security group
- EC2 IAM role and a private S3 bucket, matching the reference diagram

All resource names use `name_prefix`. The default is `yusuf`; change it if needed. The S3 bucket name includes the AWS account ID and a random suffix to satisfy global bucket-name uniqueness.

## Prerequisites

- Terraform 1.5 or newer
- AWS CLI credentials configured for an account allowed to create VPC, EC2, IAM, S3, and NAT Gateway resources
- An SSH key pair; the default public-key path is `~/.ssh/id_ed25519.pub`

The EC2 role is attached to AWS-managed `AmazonS3FullAccess` to match the supplied architecture diagram. This policy is broad; it should be narrowed to the assignment bucket for a production deployment.

## Deploy

If you do not already have a key pair, create one:

```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

Copy the example variables file. Bastion SSH is intentionally open to `0.0.0.0/0` as requested; this exposes port 22 to the internet. Use a strong key and remove or restrict this rule when broad access is no longer needed.

```sh
cp terraform.tfvars.example terraform.tfvars
```

Then initialize, review, and apply:

```sh
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

The NAT Gateway, Elastic IP, and EC2 instances incur AWS charges while provisioned. Delete the resources when you have finished collecting assignment evidence:

```sh
terraform destroy
```

## Access And Assignment Evidence

Use the output SSH commands, replacing `<path-to-private-key>` with `~/.ssh/id_ed25519` (or your private-key path). Connect to the private instance using the bastion jump option; it has no public IP and its security group accepts SSH only from the bastion.

On each instance, retrieve its identity document with the assignment command:

```sh
curl -s http://169.254.169.254/latest/dynamic/instance-identity/document
```

The instances allow IMDSv1 so that this exact command works. On the VirtualBox VM, capture the CLI evidence in the assignment's requested order:

```sh
aws sts get-caller-identity
aws ec2 describe-instances --filters Name=vpc-id,Values="$(terraform output -raw vpc_id)"
aws ec2 describe-subnets --filters Name=vpc-id,Values="$(terraform output -raw vpc_id)"
aws ec2 describe-route-tables --filters Name=vpc-id,Values="$(terraform output -raw vpc_id)"
```

For the submission file, place caller identity first, then both instance metadata documents, instance details, subnet details, and route table details. Include the exact command before each captured output.