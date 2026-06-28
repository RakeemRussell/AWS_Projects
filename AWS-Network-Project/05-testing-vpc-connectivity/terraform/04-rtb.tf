################## public rtb
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.us-east-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_us_east_1.id
  }

  tags = {
    Name = "public-rtb"
  }
}
################## public rtb route
resource "aws_route" "to internet route" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_us_east_1.id
}

################## public rtb association
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

################# private rtb
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.us-east-1.id

  tags = {
    Name = "private-rtb"
  }
}

################## PRIVATE rtb association
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-rtb.id
}