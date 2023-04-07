resource "aws_key_pair" "bastion_keypair" {
  key_name   = "${var.project_name}-bastion-key"
  public_key = var.public_key
}

resource "aws_instance" "vpn_bastion" {
  ami                     = "ami-031283ff8a43b021c" # Debian 10 from https://wiki.debian.org/Cloud/AmazonEC2Image/Buster
  instance_type           = var.bastion_instance_type
  key_name                = aws_key_pair.bastion_keypair.id
  vpc_security_group_ids  = [aws_security_group.vpn_bastion.id]
  subnet_id               = var.bastion_subnet
  private_ip              = var.bastion_private_ip
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

    tags = merge(
      var.common_tags,
      {
          Name = "${var.project_name}-vpn-bastion"
      }
  )
  user_data = templatefile("${path.module}/bastion_bootstrap.sh",
    {
      bastion_private_ip = var.bastion_private_ip,
      vpn_endpoint       = var.vpn_endpoint,
      route_1            = var.vpn_route
    })
}