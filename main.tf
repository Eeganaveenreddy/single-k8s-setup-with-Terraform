module "VPC" {
  source = "./modules/VPC"
  depends_on = [ module.iam-policy ]
}

module "iam-policy" {
  source = "./modules/IAM-POLICY"
}

module "eks" {
  source = "./modules/EKS"
  subnet_ids = [module.VPC.public_subnet_id-1, module.VPC.public_subnet_id-2]
  eks_policy_attach = module.iam-policy
  role_arn = module.iam-policy.aws_eks_cluster_role_arn_out
  node_groups = var.node_groups
  eks_cluster_role = module.iam-policy.aws_eks_cluster_role_name
}

# module "AWS-Ingress-loadbalancer" {
#   source = "./modules/AWS-Ingress-loadbalancer"
#   node_group_role_name = module.eks.node_group_role_name_output
#   eks_cluster_name = module.eks.eks_cluster_name_output
#   vpc_id = module.VPC.MAIN_TF_VPC_ID 
#   depends_on = [ module.eks ]
# }
