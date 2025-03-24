# data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet-terr-1" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  # count = length(data.aws_availability_zones.available.names)
  # availability_zone = element(data.aws_availability_zones.available.names, count.index)
  availability_zone = "ap-south-1a"
  tags = {
    Name = "subnet-terr-1"
    "kubernetes.io/role/elb"    = "1" # Required for public ALB
    "kubernetes.io/cluster/my-eks-cluster" = "owned"
  }
}

output "public_subnet_id-1" {
  value = aws_subnet.subnet-terr-1.id
}

resource "aws_subnet" "subnet-terr-2" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-terr-2"
    "kubernetes.io/role/elb"    = "1" # Required for public ALB
    "kubernetes.io/cluster/my-eks-cluster" = "owned"
  }
}


output "public_subnet_id-2" {
  value = aws_subnet.subnet-terr-2.id
}


resource "aws_subnet" "private-subnet-terr-2" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet-terr-2"
    "kubernetes.io/role/internal-elb"  = "1" # Required for internal ALB
    "kubernetes.io/cluster/my-eks-cluster" = "owned"
  }
}