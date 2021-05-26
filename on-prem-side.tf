module "on-prem" {
  source             = "./simulated_on_prem"
  AWS_SECRET_ID      = var.AWS_SECRET_ID
  AWS_KEY_ID         = var.AWS_KEY_ID
  tunnel1_public_ip  = aws_vpn_connection.main.tunnel1_address
  tunnel1_shared_key = aws_vpn_connection.main.tunnel1_preshared_key
  aws_tunnel_1_insde_ip = aws_vpn_connection.main.tunnel1_vgw_inside_address
  on_prem_tunnel_1_inside_ip = aws_vpn_connection.main.tunnel1_cgw_inside_address

  tunnel2_public_ip  = aws_vpn_connection.main.tunnel2_address
  tunnel2_shared_key = aws_vpn_connection.main.tunnel2_preshared_key
  aws_tunnel_2_insde_ip = aws_vpn_connection.main.tunnel2_vgw_inside_address
  on_prem_tunnel_2_inside_ip = aws_vpn_connection.main.tunnel2_cgw_inside_address
}