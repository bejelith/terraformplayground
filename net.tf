resource "aws_vpc" "VPC-1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name      = "VPC-1"
    Preferred = "true"
  }
}

resource "aws_internet_gateway" "internet_gateway-1" {
  vpc_id = aws_vpc.VPC-1.id
}

resource "aws_route_table" "rt-vpc-1" {
  vpc_id = aws_vpc.VPC-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway-1.id
  }
}


resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.BASTION-1.id
  route_table_id = aws_route_table.rt-vpc-1.id
}

resource "aws_default_network_acl" "VPCACL-1" {
  default_network_acl_id = "${aws_vpc.VPC-1.default_network_acl_id}"
  ingress {
    rule_no = 10
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    action = "allow"
    cidr_block = "0.0.0.0/0"
  }
  egress {
    rule_no = 20
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    action = "allow"
    cidr_block = "0.0.0.0/0"
  }
}


resource "aws_default_security_group" "sg1" {
  vpc_id = aws_vpc.VPC-1.id

  ingress {
      cidr_blocks = ["0.0.0.0/0"]
      description = null
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
  }

  egress {
      cidr_blocks = ["0.0.0.0/0"]
      description = null
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
  }
  
}