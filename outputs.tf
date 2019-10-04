output "agent_iam_role_arn" {
  description = "IAM Role ARN for agents"
  value       = aws_iam_instance_profile.agent.arn
}

output "agent_iam_role_name" {
  description = "IAM Role name for agents"
  value       = aws_iam_instance_profile.agent.name
}

output "agent_security_group_id" {
  description = "ID of the security group for agents"
  value       = aws_security_group.agent.*.id
}

output "server_iam_policy_arn" {
  description = "ARN of IAM policy to attach to TeamCity server's user or IAM instance profile for managing agents"
  value       = aws_iam_policy.teamcity_server_cloud_agents.arn
}

output "server_iam_policy_name" {
  description = "Name of IAM policy to attach to TeamCity server's user or IAM instance profile for managing agents"
  value       = aws_iam_policy.teamcity_server_cloud_agents.name
}

output "server_user_name" {
  description = "Name of the TeamCity server user created"
  value       = var.teamcity_server_user_name != "" ? aws_iam_user.server.*.name[0] : ""
}

output "server_user_arn" {
  description = "ARN of the TeamCity server user created"
  value       = var.teamcity_server_user_name != "" ? aws_iam_user.server.*.arn[0] : ""
}
