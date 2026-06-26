resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.us-east-1.id
  cidr_block = "10.90.1.0/24"

  tags = {
    Name = "public_subnet"
  }
}
# test change
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.us-east-1.id
  cidr_block = "10.90.11.0/24"

  tags = {
    Name = "private_subnet"
  }
}