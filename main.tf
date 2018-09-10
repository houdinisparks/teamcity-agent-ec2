module "server_policy" {
  source = "modules/server_policy"

  ami_ids      = ["${var.ami_ids}"]
  key_pair_ids = ["${var.key_pair_ids}"]
  subnet_ids   = ["${var.subnet_ids}"]
  vpc_ids      = ["${var.vpc_ids}"]
  allow_spot   = "${var.allow_spot}"

  agent_role_arn             = "${aws_iam_role.agent.arn}"
  agent_instance_profile_arn = "${aws_iam_instance_profile.agent.arn}"
  security_group_ids         = ["${aws_security_group.agent.id}"]
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "agent" {
  name = "${var.instance_profile_name}"

  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume.json}"
  description        = "IAM Role for TeamCity agents"
}

resource "aws_iam_instance_profile" "agent" {
  name = "${var.instance_profile_name}"
  role = "${aws_iam_role.agent.name}"
}

resource "aws_security_group" "agent" {
  count = "${length(var.vpc_ids)}"

  name        = "${var.security_group_name}"
  description = "Security group for agents in VPC ${element(var.vpc_ids, count.index)}"
  vpc_id      = "${element(var.vpc_ids, count.index)}"

  tags = "${merge(var.tags, map("Name", "${var.security_group_name}"))}"
}

resource "aws_iam_policy" "teamcity_server_cloud_agents" {
  name        = "${var.server_policy_name}"
  description = "IAM Policy to allow TeamCity server to manage cloud agents"
  policy      = "${module.server_policy.json}"
}

resource "aws_iam_role_policy_attachment" "server_cloud_agent" {
  count = "${var.use_iam_role ? 1 : 0}"

  role       = "${var.teamcity_server_iam_role}"
  policy_arn = "${aws_iam_policy.teamcity_server_cloud_agents.arn}"
}

resource "aws_iam_user" "server" {
  count = "${var.teamcity_server_user_name != "" ? 1 : 0}"
  name  = "${var.teamcity_server_user_name}"
}

resource "aws_iam_user_policy_attachment" "server_cloud_agent" {
  count      = "${var.teamcity_server_user_name != "" ? 1 : 0}"
  user       = "${aws_iam_user.server.*.name[0]}"
  policy_arn = "${aws_iam_policy.teamcity_server_cloud_agents.arn}"
}
