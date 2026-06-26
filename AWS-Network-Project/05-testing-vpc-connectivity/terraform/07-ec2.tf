################ PUBLIC EC2
resource "aws_instance" "public_ec2" {
  ami           = "ami-08f44e8eca9095668" # Amazon Linux 2 (example - may vary by region)
  instance_type = "t3.micro"

  tags = {
    Name = "public_ec2"
  }
}

################ PRIVATE EC2
resource "aws_instance" "private_ec2" {
  ami           = "ami-08f44e8eca9095668" # Amazon Linux 2 (example - may vary by region)
  instance_type = "t3.micro"

  tags = {
    Name = "private_ec2"
  }
}