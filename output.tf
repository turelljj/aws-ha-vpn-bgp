output "presharedkey-tunnel1" {
  value = aws_vpn_connection.main.tunnel1_preshared_key
}

output "presharedkey-tunnel2" {
  value = aws_vpn_connection.main.tunnel2_preshared_key
}

output "cgw_inside_address_tunnel1" { value = aws_vpn_connection.main.tunnel1_cgw_inside_address }

output "cgw_inside_address_tunnel2" { value = aws_vpn_connection.main.tunnel2_cgw_inside_address }

output "vgw_inside_address_tunnel1" { value = aws_vpn_connection.main.tunnel1_vgw_inside_address }

output "vgw_inside_address_tunnel2" { value = aws_vpn_connection.main.tunnel2_vgw_inside_address }

output "bgp_asn_tunnel1" { value = aws_vpn_connection.main.tunnel1_bgp_asn }

output "bgp_asn_tunnel2" { value = aws_vpn_connection.main.tunnel2_bgp_asn }

output "tunnel1_address" {
  value = aws_vpn_connection.main.tunnel1_address
}

output "tunnel2_address" {
  value = aws_vpn_connection.main.tunnel2_address
}

output "vpn_tester_ip" { value = aws_instance.vpn-tester.private_ip }

output "testing_command" { 
  value = "ssh centos@${module.on-prem.on_prem_public_ip} ping ${aws_instance.vpn-tester.private_ip} -I ${module.on-prem.on_prem_private_ip}"
  }