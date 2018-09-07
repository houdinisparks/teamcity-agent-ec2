variable "agent_instance_profile_arn" {
  description = "ARN of the Instance profile to be assigned to TeamCity Agents"
}

variable "ami_ids" {
  description = "List of AMI IDs that can be launched by the TeamCity server"
  default     = ["*"]
}

variable "subnet_ids" {
  description = "List of Subnet IDs that instances can be launched into by TeamCity server"
  default     = ["*"]
}

variable "key_pair_ids" {
  description = "List of Key Pair IDs that can be used with instances launched by TeamCity server"
  default     = ["*"]
}

variable "security_group_ids" {
  description = "List of security group IDs that can be attached to instances launched by TeamCity server"
  default     = ["*"]
}

variable "vpc_ids" {
  description = "List of VPC IDs that instances can be launched into by TeamCity server"
  default     = ["*"]
}

variable "allow_spot" {
  description = "Allow TeamCity server to use spot instances"
  default     = false
}

variable "use_iam_role" {
  description = "Allow TeamCity server to use IAM Roles"
  default     = false
}
