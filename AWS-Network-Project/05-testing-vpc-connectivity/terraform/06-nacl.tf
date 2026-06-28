############## PUBLIC NACL ########################
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.us-east-1.id

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

    egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

    egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  tags = {
    Name = "public_nacl"
  }
}

############## PUBLIC NACL ASSOCIATION ########################
resource "aws_network_acl_association" "public_nacl_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.public_nacl.id
}

############## PRIVATE NACL #########################
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.us-east-1.id

  egress {
    protocol   = "-1"
    rule_no    = 150
    action     = "allow"
    cidr_block = aws_vpc.us-east-1.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 160
    action     = "allow"
    cidr_block = aws_vpc.us-east-1.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "private_nacl"
  }
}

############## PRIVATE NACL ASSOCIATION ########################
resource "aws_network_acl_association" "private_nacl_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  network_acl_id = aws_network_acl.private_nacl.id
}