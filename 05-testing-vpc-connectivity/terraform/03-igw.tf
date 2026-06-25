resource "aws_internet_gateway" "igw_us_east_1" {
  vpc_id = aws_vpc.us-east-1

  tags = {
    Name = "igw_us_east_1"
  }
}