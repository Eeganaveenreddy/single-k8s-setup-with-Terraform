resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
}

output "MAIN_TF_VPC_ID" {
  value = aws_vpc.tf_vpc.id
}
