data "aws_caller_identity" "current" {}
data "aws_iam_user" "iam_user" {
  user_name = split("/", data.aws_caller_identity.current.arn)[1]
}

output "out" {
  value = data.aws_iam_user.iam_user.user_name
}