resource "aws_security_group" "vpn_bastion" {
  name        = "vpn_bastion"
  description = "Allows SSH and VPN to Bastion from everywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows SSH from GitHub and VPN"
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows VPN from everywhere"
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
          Name = "${var.project_name}-vpn-bastion"
      }
  )  
}

output "vpn_bastion_secgroup" {
  value = aws_security_group.vpn_bastion.id
}