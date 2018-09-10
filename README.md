# TeamCity Agents on EC2

This repository contains Terraform Module and Packer AMI template to run
[TeamCity agents on demand on EC2](https://confluence.jetbrains.com/display/TCD18/Setting+Up+TeamCity+for+Amazon+EC2).

## Cloing the Repository

This repository contains submodules. Clone with

```bash
git clone --recurse-submodules https://github.com/gdsace/teamcity-agent-ec2.git
```

## Terraform Module

The Terraform module provisions the following:

- Security Group for TeamCity agents (no rules -- you have to define your own)
- Create an instance profile for agents (with no policies attached)
- IAM policy to allow TeamCity to manage agent instances *only* in the VPC
- (Optional) control access to specific subnets in the VPC or a specific VPC
- Either create a user or an IAM Instance role for TeamCity server and attach the policy provisioned by this module to the user or role.

After provisioning the Module, you will need to do the following:

- Assign rules to the Security Group provisioned so that your instances can reach the TeamCity server or any other resources your builds require
- Optionally attach any policies to the IAM instance profile for your agents.
- Create an Access Key and Secret for your IAM user if you are using it with Terraform or the AWS Console.

Options (Generate Kotlin code):
- One per subnet
- IAM Profile
- Key pair
- Instance Type
- SG
- user_data
- tags (Name!) -

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow_spot | Allow TeamCity server to use spot instances | string | `false` | no |
| ami_ids | List of AMI IDs that can be launched by the TeamCity server | string | `<list>` | no |
| instance_profile_name | Name to attach to agent instance profile | string | `teamcity-agent` | no |
| key_pair_ids | List of Key Pair IDs that can be used with instances launched by TeamCity server | string | `<list>` | no |
| security_group_name | Name of the security group | string | `teamcity-agent` | no |
| server_policy_name | Name of the policy to allow TeamCity servers to manage cloud agents | string | `teamcity-server-cloud-agents` | no |
| subnet_ids | List of Subnet IDs that instances can be launched into by TeamCity server | string | `<list>` | no |
| tags | Tags for resouces that support it | string | `<map>` | no |
| teamcity_server_iam_role | If `use_iam_role` is true, provide the name to the TeamCity role | string | `` | no |
| teamcity_server_user_name | If provided, creates an IAM user with this user name and have the policy attached | string | `` | no |
| use_iam_role | Attach policy to TeamCity server IAM role | string | `false` | no |
| vpc_ids | List of VPC IDs that instances can be launched into by TeamCity server | list | - | yes |

### Outputs

| Name | Description |
|------|-------------|
| agent_iam_role_arn | IAM Role ARN for agents |
| agent_iam_role_name | IAM Role name for agents |
| agent_security_group_id | ID of the security group for agents |
| server_iam_policy_arn | ARN of IAM policy to attach to TeamCity server's user or IAM instance profile for managing agents |
| server_iam_policy_name | Name of IAM policy to attach to TeamCity server's user or IAM instance profile for managing agents |
| server_user_arn | ARN of the TeamCity server user created |
| server_user_name | Name of the TeamCity server user created |

### Child Modules

For reusability, the root module makes use of some child modules.

#### `server_policy`

This module creates the IAM Policy that should be given to the entity (either instance profile or
IAM user) that is provided to a TeamCity server for it to manage its cloud profile agents.

## Packer Template

The Packer template installs the following:

- Installs JRE, Git
- Creates a `teamcity` user
- Installs [TeamCity Agnets](https://confluence.jetbrains.com/display/TCD18//Setting+up+and+Running+Additional+Build+Agents)
- Configures the agent to point to your TeamCity server
- Installs Docker and Docker Compose
- Allow `teamcity` user to execute Docker
- Configures TeamCity agent to autostart and run under the `teamcity` user

### Building the template

Specify the variables in `packer.json` in another file (e.g. `vars.json`) and then build the image
with

```bash
packer build --var-file vars.json packer.json
```
