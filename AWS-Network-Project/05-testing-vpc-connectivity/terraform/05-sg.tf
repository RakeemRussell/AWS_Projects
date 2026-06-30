###########   public sg ############
resource "aws_security_group" "sg_public" {
  name        = "sg_public"
  description = "public security group"
  vpc_id      = aws_vpc.us-east-1.id

  tags = {
    Name = "public security group"
  }
}

###########   public sg rules ############
resource "aws_vpc_security_group_ingress_rule" "allow_https_rule" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_rule" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow-all-inbound" {
  security_group_id = aws_security_group.sg_public.id
  referenced_security_group_id = aws_security_group.sg_private.id
  from_port         = -1
  ip_protocol       = "-1"
  to_port           = -1
  
}

resource "aws_vpc_security_group_egress_rule" "allow-all-public-outbound" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = -1
  to_port           = -1

}
###########   private sg ############
resource "aws_security_group" "sg_private" {
  name        = "sg_private"
  description = "private security group"
  vpc_id      = aws_vpc.us-east-1.id

  tags = {
    Name = "private security group"
  }
}

###########   private sg rules ############
resource "aws_vpc_security_group_ingress_rule" "sg_private_allow_ssh_rule" {
  security_group_id = aws_security_group.sg_private.id
  referenced_security_group_id = aws_security_group.sg_public.id

  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  
}

resource "aws_vpc_security_group_ingress_rule" "sg_private_allow_icmp_rule" {
  security_group_id = aws_security_group.sg_private.id
  referenced_security_group_id = aws_security_group.sg_public.id

  from_port         = -1
  to_port           = -1
  ip_protocol       = "icmp"
  
}

resource "aws_vpc_security_group_egress_rule" "allow-all-private-outbound" {
  security_group_id = aws_security_group.sg_private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}