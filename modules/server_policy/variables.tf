variable "agent_instance_profile_arn" {
  description = "ARN of the Instance profile to be assigned to TeamCity Agents"
}

variable "agent_role_arn" {
  description = "ARN of the role that is assigned to the instance profile for TeamCity agents"
}

variable "ami_ids" {
  description = "List of AMI IDs that can be launched by the TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "subnet_ids" {
  description = "List of Subnet IDs that instances can be launched into by TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "key_pair_ids" {
  description = "List of Key Pair IDs that can be used with instances launched by TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "security_group_ids" {
  description = "List of security group IDs that can be attached to instances launched by TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "vpc_ids" {
  description = "List of VPC IDs that instances can be launched into by TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "allow_spot" {
  description = "Allow TeamCity server to use spot instances"
  default     = false
}

variable "allow_modify_instance_attribute" {
  description = "Allow Teamcity server to modify the instances attribute."
  default     = false
}
