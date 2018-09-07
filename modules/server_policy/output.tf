output "json" {
  description = "Rendered IAM Policy document JSON"
  value       = "${data.aws_iam_policy_document.teamcity_server_cloud_profile.json}"
}
