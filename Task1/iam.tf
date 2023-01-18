# resource "aws_iam_policy" "name" {
#   name = "ec2_ssm_po"
#   policy = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
# }
resource "aws_iam_role" "ec2_roles" {
  name = "ec2_ssm_role"
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
assume_role_policy = data.aws_iam_policy_document.ssm-assume-role-policy.json
managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]
}

data "aws_iam_policy_document" "ssm-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ec2_roles.name
}