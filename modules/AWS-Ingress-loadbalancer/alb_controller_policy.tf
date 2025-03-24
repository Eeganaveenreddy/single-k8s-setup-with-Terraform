# Create IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for ALB Controller"
  policy      = file("modules/AWS-Ingress-loadbalancer/alb_controller_policy.json") # Download from AWS Docs
}

# Attach Policy to EKS Node IAM Role
resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = var.node_group_role_name
}
