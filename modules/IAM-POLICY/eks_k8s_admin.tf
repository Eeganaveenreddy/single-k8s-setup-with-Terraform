resource "aws_iam_policy" "eks_k8s_admin" {
  name        = "EKS-K8S-Admin"
  description = "EKS Kubernetes Admin Access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:AccessKubernetesApi"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_k8s_admin_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.eks_k8s_admin.arn
}
