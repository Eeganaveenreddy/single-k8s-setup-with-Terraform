resource "aws_security_group" "pod_sg" {
  name        = "pod-security-group"
  description = "Security group for EKS pods"
  vpc_id      = var.vpc_id  # Replace with your VPC ID

  # Allow outbound traffic (so pods can reach the internet if needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
