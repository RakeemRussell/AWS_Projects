###########   public sg ############
resource "aws_security_group" "sg_public" {
  name        = "sg_public"
  description = "public security group"
  vpc_id      = aws_vpc.us-east-1.id

  tags = {
    Name = "public security group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_rule" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = aws_vpc.us-east-1.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_rule" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
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

resource "aws_vpc_security_group_ingress_rule" "sg_private_allow_tls_rule" {
  security_group_id = aws_security_group.sg_private.id
  cidr_ipv4         = aws_vpc.us-east-1.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "sg_private_allow_all_traffic_rule" {
  security_group_id = aws_security_group.sg_private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
