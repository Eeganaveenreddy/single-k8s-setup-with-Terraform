# resource "aws_iam_policy" "iam_policy" {
#   name        = "iam-user-policy"
#   description = "Allows Terraform to create and manage IAM users"
#   policy      = file("modules/IAM-POLICY/iam-user-policy.json")

# }

# # If you want to fetch the IAM username of the currently authenticated user (the one running Terraform),
# # data "aws_caller_identity" "current" {}
# # data "aws_iam_user" "iam_user" {
# #   user_name = split("/", data.aws_caller_identity.current.arn)[1]
# # }

# module "data" {
#   source = "../../data"
# }

# resource "aws_iam_user_policy_attachment" "iam_user_policy_attach" {
#   # user       = data.aws_iam_user.iam_user.user_name
#   user = module.data.out
#   policy_arn = aws_iam_policy.iam_policy.arn
# }

