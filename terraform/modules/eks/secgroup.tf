resource "aws_security_group" "eks_api" {
  name        = "eks_api"
  description = "Allows access to the EKS on port 443"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = var.eks_api_access
    from_port       = 443
    to_port         = 443
    protocol        = "TCP"
    description     = "Allows traffic from this security group on port 443"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = merge(
      var.common_tags,
      {
        Name = "eks_api"
      }
  )

}

output "eks_api_secgroups" {
  value = [aws_security_group.eks_api.id]
}