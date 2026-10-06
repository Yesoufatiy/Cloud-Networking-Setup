output "vpc_id" {
  description = "VPC ID for the assignment AWS CLI queries."
  value       = aws_vpc.main.id
}

output "public_instance_id" {
  value = aws_instance.bastion.id
}

output "public_instance_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "private_instance_private_ip" {
  value = aws_instance.private.private_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.assignment.id
}

output "ssh_bastion_command" {
  value = "ssh -i <path-to-private-key> ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_private_via_bastion_command" {
  value = "ssh -i <path-to-private-key> -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.private.private_ip}"
}