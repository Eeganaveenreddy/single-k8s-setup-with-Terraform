# resource "aws_iam_policy" "ec2_policy" {
#   name        = "ec2-policies"
#   description = "Allows Terraform to create and manage EC2 instances"
#   policy      = file("modules/IAM-POLICY/ec2-access-policy.json")

# }

# resource "aws_iam_user_policy_attachment" "ec2_policy_attach" {
#   # user       = data.aws_iam_user.iam_user.user_name
#   user = module.data.out
#   policy_arn = aws_iam_policy.ec2_policy.arn
# }

