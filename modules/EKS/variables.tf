variable "subnet_ids" {
    type = list(string)
}

variable "eks_policy_attach" {}

variable "role_arn" {
    type = string
}

variable "eks_cluster_role" {
  type = string
}

variable "node_groups" {
  description = "Map of node groups"
  type = map(object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
  }))
}

variable "region" {
  default = "ap-south-1"
  type = string
}
