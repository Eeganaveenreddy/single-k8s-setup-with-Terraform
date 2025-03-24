# resource "aws_iam_policy" "s3-access-policy" {
#   name        = "s3-access-policy"
#   description = "IAM policy for S3 bucket access"
#   policy      = file("modules/IAM-POLICY/s3-access-policy.json")
# }

# # # If you want to fetch the IAM username of the currently authenticated user (the one running Terraform),
# # data "aws_caller_identity" "current" {}

# # data "aws_iam_user" "iam_user" {
# #   user_name = split("/", data.aws_caller_identity.current.arn)[1]
# # }

# resource "aws_iam_user_policy_attachment" "s3_policy_attachment" {
#   user       = data.aws_iam_user.iam_user.user_name
#   policy_arn = aws_iam_policy.s3-access-policy.arn
# }
