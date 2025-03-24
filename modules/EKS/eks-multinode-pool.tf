resource "aws_eks_node_group" "eks_node_groups" {
  cluster_name    = aws_eks_cluster.eks_cluster.name

  for_each = var.node_groups
  
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = each.value.instance_types

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  remote_access {
    ec2_ssh_key = "my-keypair"
  }

  ami_type      = "AL2_x86_64"
  disk_size     = 20
  capacity_type = "ON_DEMAND"

  tags = {
    Name = "${each.key}"
  }
}


