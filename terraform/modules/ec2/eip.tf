resource "aws_eip" "vpn_bastion" {
  instance = aws_instance.vpn_bastion.id
  vpc      = true

    tags = merge(
      var.common_tags,
      {
          Name = "${var.project_name}-vpn-bastion"
      }
  )  
}