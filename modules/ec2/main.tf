resource "aws_instance" "test-instance" {
  ami = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  availability_zone = var.availability_zone
  vpc_security_group_ids = [aws_security_group.terra-sg.id]

  tags = {
    name = "test-inatnce"
  }
}