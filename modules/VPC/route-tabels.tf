#public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    name = "public-rout-table"
  }
}

#Attache IGW to public route table
resource "aws_route" "public_rt" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#Association route table to public subnet
resource "aws_route_table_association" "rt-association"{
    subnet_id = aws_subnet.subnet-terr-1.id
    route_table_id = aws_route_table.public_rt.id
}

#Association route table to public subnet-2 subnet
resource "aws_route_table_association" "rt-association-to-public-subnet"{
    subnet_id = aws_subnet.subnet-terr-2.id
    route_table_id = aws_route_table.public_rt.id
}


#private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    name = "private-rout-table"
  }
}

resource "aws_route_table_association" "rt-association-to-private-subnet"{
    subnet_id = aws_subnet.private-subnet-terr-2.id
    route_table_id = aws_route_table.private_rt.id
}
