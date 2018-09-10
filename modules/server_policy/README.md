# `server_policy`

This module creates the IAM Policy that should be given to the entity (either instance profile or
IAM user) that is provided to a TeamCity server for it to manage its cloud profile agents.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| agent_instance_profile_arn | ARN of the Instance profile to be assigned to TeamCity Agents | string | - | yes |
| allow_spot | Allow TeamCity server to use spot instances | string | `false` | no |
| ami_ids | List of AMI IDs that can be launched by the TeamCity server | string | `<list>` | no |
| key_pair_ids | List of Key Pair IDs that can be used with instances launched by TeamCity server | string | `<list>` | no |
| security_group_ids | List of security group IDs that can be attached to instances launched by TeamCity server | string | `<list>` | no |
| subnet_ids | List of Subnet IDs that instances can be launched into by TeamCity server | string | `<list>` | no |
| vpc_ids | List of VPC IDs that instances can be launched into by TeamCity server | string | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| json | Rendered IAM Policy document JSON |
