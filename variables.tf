variable "vpc_ids" {
  description = "List of VPC IDs that instances can be launched into by TeamCity server"
  type        = list(string)
}

############################
# Optional
############################
variable "subnet_ids" {
  description = "List of Subnet IDs that instances can be launched into by TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "server_policy_name" {
  description = "Name of the policy to allow TeamCity servers to manage cloud agents"
  default     = "teamcity-server-cloud-agents"
}

variable "ami_ids" {
  description = "List of AMI IDs that can be launched by the TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "key_pair_ids" {
  description = "List of Key Pair IDs that can be used with instances launched by TeamCity server"
  type        = list(string)

  default = ["*"]
}

variable "allow_spot" {
  description = "Allow TeamCity server to use spot instances"
  default     = false
}

variable "use_iam_role" {
  description = "Attach policy to TeamCity server IAM role"
  default     = false
}

variable "teamcity_server_iam_role" {
  description = "If `use_iam_role` is true, provide the name to the TeamCity role"
  default     = ""
}

variable "teamcity_server_user_name" {
  description = "If provided, creates an IAM user with this user name and have the policy attached"
  default     = ""
}

variable "instance_profile_name" {
  description = "Name to attach to agent instance profile"
  default     = "teamcity-agent"
}

variable "security_group_name" {
  description = "Name of the security group"
  default     = "teamcity-agent"
}

variable "tags" {
  description = "Tags for resouces that support it"
  type        = map(string)

  default = {
    Terraform = "true"
  }
}

variable "allow_modify_instance_attribute" {
  description = "Allow Teamcity server to modify the instances attribute."
  default     = false
}
