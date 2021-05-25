module "on-prem" {
  source             = "./simulated_on_prem"
  AWS_SECRET_ID      = var.AWS_SECRET_ID
  AWS_KEY_ID         = var.AWS_KEY_ID
  tunnel1_public_ip  = aws_vpn_connection.main.tunnel1_address
  tunnel1_shared_key = aws_vpn_connection.main.tunnel1_preshared_key
#   vpn_vpc_cidr       = module.vpc-1.vpc_cidr_block
  on_prem_tunnel_ip = aws_vpn_connection.main.tunnel1_cgw_inside_address
  aws_tunnel_ip = aws_vpn_connection.main.tunnel1_vgw_inside_address
}