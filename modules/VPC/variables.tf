variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

output "ap-south-1a" {
  value = var.azs[0]
}

output "ap-south-1b" {
  value = var.azs[1]
}

output "ap-south-1c" {
  value = var.azs[2]
}