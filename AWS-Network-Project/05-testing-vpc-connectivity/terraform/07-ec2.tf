################ PUBLIC EC2
resource "aws_instance" "public_ec2" {
  ami           = "ami-08f44e8eca9095668" # Amazon Linux 2 (example - may vary by region)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.sg_public.id
  ]
  tags = {
    Name = "public_ec2"
  }
}

################ PRIVATE EC2
resource "aws_instance" "private_ec2" {
  ami           = "ami-08f44e8eca9095668" # Amazon Linux 2 (example - may vary by region)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.sg_private.id
  ]
  tags = {
    Name = "private_ec2"
  }
}