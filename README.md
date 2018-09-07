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

- VPC to contain the TeamCity agents in either public or private subnets
- IAM policy to allow TeamCity to manage agent instances *only* in the VPC
- (Optional) control access to specific subnets in the VPC
- Either IAM User to provide to TeamCity or attach an IAM policy to a role that TeamCity server uses

Options (Generate Kotlin code):
- One per subnet
- IAM Profile
- Key pair
- Instance Type
- SG
- user_data
- tags (Name!) -

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
