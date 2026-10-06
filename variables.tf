variable "name_prefix" {
  description = "Your name, used as the prefix for every named resource."
  type        = string
  default     = "student"
}

variable "aws_region" {
  description = "AWS region for the network and instances."
  type        = string
  default     = "us-east-2"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key to install on both instances."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "instance_type" {
  description = "EC2 instance type for the bastion and private instance."
  type        = string
  default     = "t3.micro"
}