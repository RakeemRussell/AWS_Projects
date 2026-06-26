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

################# private rtb
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.us-east-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_us_east_1.id
  }

  tags = {
    Name = "private-rtb"
  }
}
