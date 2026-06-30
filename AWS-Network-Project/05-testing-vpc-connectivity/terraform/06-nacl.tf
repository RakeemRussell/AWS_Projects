############## PUBLIC NACL ########################
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.us-east-1.id
    egress {
    protocol   = "-1"
    rule_no    = 160
    action     = "allow"
   cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 160
    action     = "allow"
   cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
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
    rule_no    = 170
    action     = "allow"
    cidr_block = aws_vpc.us-east-1.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 180
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