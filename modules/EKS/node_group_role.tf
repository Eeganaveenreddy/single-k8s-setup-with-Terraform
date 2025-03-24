resource "aws_iam_role" "node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

output "node_group_role_name_output" {
  value = aws_iam_role.node_group_role.name
}
