resource "aws_subnet" "DMZ-1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.VPC-1.id
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags =  {
    Name = "DMZ-1"
  }
}

resource "aws_subnet" "DATA-1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.VPC-1.id
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags =  {
    Name = "DATA-1"
  }
}

resource "aws_subnet" "SERVICE-1" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.VPC-1.id
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags =  {
    Name = "SERVICE-1"
  }
}


resource "aws_subnet" "BASTION-1" {
  cidr_block              = "10.0.3.0/24"
  vpc_id                  = aws_vpc.VPC-1.id
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags =  {
    Name = "BASTION-1"
  }
}
