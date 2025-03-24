# Since the NLB is directly sending traffic to pod IPs, we need to allow traffic from the NLB.
resource "aws_security_group_rule" "allow_nlb_to_pods" {
  type                     = "ingress"
  from_port                = 80   # HTTP port
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.pod_sg.id  # Attach to Pod Security Group
  source_security_group_id = aws_security_group.nlb_sg.id   # Allow traffic from NLB
}
