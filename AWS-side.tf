provider "aws" {
  region     = "ap-northeast-1"
  access_key = var.AWS_KEY_ID
  secret_key = var.AWS_SECRET_ID
}

module "vpc-1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "vpc-AWS"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1c"]
  private_subnets = ["10.0.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = true
  create_igw         = false

  propagate_private_route_tables_vgw = true #route propagate enabled for private_subnet

  tags = {
    Terraform   = "true"
    Environment = "AWS"
  }
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = module.on-prem.on_prem_public_ip
  type       = "ipsec.1"

  tags = {
    Name = "simulated-on-prem"
  }
}


resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = module.vpc-1.vgw_id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = "ipsec.1"
  # tunnel1_bgp_asn     = 64512
  # tunnel2_bgp_asn     = 64513
}

resource "aws_instance" "vpn-tester" {
  ami                    = "ami-06098fd00463352b6"
  instance_type          = "t2.micro"
  key_name               = "macbook"
  subnet_id              = module.vpc-1.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  user_data              = <<EOF
        #!/bin/bash
        python -m SimpleHTTPServer 8080
        EOF
}

resource "aws_security_group" "allow-ssh" {
  vpc_id = module.vpc-1.vpc_id
  name   = "allow-ssh"
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow-ssh"
    from_port        = 22
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 22
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow-ssh"
    from_port        = 8080
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 8080
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow-icmp"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = -1
    security_groups  = null
    self             = false
    to_port          = 0
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow-ssh"
    from_port        = 8080
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 8080
  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "value"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "-1"
    security_groups  = null
    self             = false
    to_port          = 0
  }]

  tags = {
    "Name" = "allow-ssh"
  }
}