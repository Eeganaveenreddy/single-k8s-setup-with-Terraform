# resource "aws_iam_policy" "vpc-access-policy" {
#   name        = "vpc-access-policy"
#   description = "IAM policy for VPC"
#   policy      = file("modules/IAM-POLICY/vpc-access-policy.json")

# }

# resource "aws_iam_user_policy_attachment" "vpc_policy_attach" {
#   # user       = data.aws_iam_user.iam_user.user_name
#   user = module.data.out
#   policy_arn = aws_iam_policy.vpc-access-policy.arn
# }