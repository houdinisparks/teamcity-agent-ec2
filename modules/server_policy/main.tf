locals {
  ami_arns            = "${formatlist("arn:aws:ec2:*:*:image/%s", var.ami_ids)}"
  subnet_arns         = "${formatlist("arn:aws:ec2:*:*:subnet/%s", var.subnet_ids)}"
  key_pair_arns       = "${formatlist("arn:aws:ec2:*:*:key-pair/%s", var.key_pair_ids)}"
  security_group_arns = "${formatlist("arn:aws:ec2:*:*:security-group/%s", var.security_group_ids)}"
  vpc_arns            = "${formatlist("arn:aws:ec2:*:*:vpc/%s", var.vpc_ids)}"

  run_instances_wildcard = [
    "arn:aws:ec2:*:*:instance/*",
    "arn:aws:ec2:*:*:volume/*",
    "arn:aws:ec2:*:*:network-interface/*",
    "arn:aws:ec2:*:*:launch-template/*",
    "arn:aws:ec2:*:*:placement-group/*",
    "arn:aws:ec2:*:*:snapshot/*",
    "arn:aws:ec2:*:*:elastic-gpu/*",
  ]

  run_instances_resources = ["${sort(concat(local.run_instances_wildcard, local.ami_arns, local.subnet_arns, local.key_pair_arns, local.security_group_arns))}"]
}

data "aws_iam_policy_document" "teamcity_server_cloud_profile" {
  policy_id = "teamcity_server_cloud_profile"

  statement {
    sid    = "DescribeAll"
    effect = "Allow"

    actions = [
      "ec2:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "InstanceProfileRestrictions"

    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:TerminateInstances",
    ]

    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "ec2:InstanceProfile"
      values   = ["${var.agent_instance_profile_arn}"]
    }
  }

  statement {
    sid = "RunInstances"

    actions = [
      "ec2:RunInstances",
    ]

    resources = ["${local.run_instances_resources}"]

    condition {
      test     = "ArnEqualsIfExists"
      variable = "ec2:Vpc"
      values   = ["${local.vpc_arns}"]
    }

    condition {
      test     = "ArnEqualsIfExists"
      variable = "ec2:InstanceProfile"
      values   = ["${var.agent_instance_profile_arn}"]
    }
  }

  statement {
    sid = "ManageTags"

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]

    resources = ["*"]
  }

  statement {
    sid = "SpotInstances"

    actions = [
      "ec2:RequestSpotInstances",
      "ec2:CancelSpotInstanceRequests",
    ]

    effect = "${var.allow_spot ? "Allow" : "Deny"}"

    resources = ["*"]
  }

  statement {
    sid = "ListIamProfiles"

    actions = [
      "iam:ListInstanceProfiles",
    ]

    resources = ["*"]
  }

  statement {
    sid = "PassRole"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "${var.agent_role_arn}",
    ]

    condition {
      test = "StringEquals"
      variable = "iam:PassedToService"
      values = ["ec2"]
    }
  }
}
