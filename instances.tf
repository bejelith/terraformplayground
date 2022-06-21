resource "aws_key_pair" "rootkey" {
    public_key =  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgrVfqpVVWOqk+qGCmljnFeyk4eYtgpQVgq45S8RwW+fv12YgCKanbqkViJBhmR0ngh6d6Kl/pk+TCvAsX9jMd6u4dpMtxWI3Keusjc5zVyCIihH/LCE2azWCglt/Ms4L3QejvmR0XxGKgna+W7Yjn0RCQrWMqktU2i4TFGwudyZwO0lCGPapLtye+XIuDPdH9HlkJwt15T87L5bJ4nROxxprJbLzbaRsqXndCPySETqaR2f9j7yT0H36CIMAZkMnipQu1mtKpjAq7ksZ9vaN9LNglNVxfro+jV1hLZ/cBNmdK+rxF3p+NxAVnX6AEQiU6AAx4sBEJu59Qi8qk+QAP simone.caruso@SCARUSO-01.local"
}

resource "aws_security_group" "bastions-sg" {
  name        = "Bastions-SG"
  description = "Allow inbound traffic from application layer"
  vpc_id      = aws_vpc.VPC-1.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-SG"
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.nano"
  
  subnet_id     = "${aws_subnet.BASTION-1.id}"
  
  key_name = aws_key_pair.rootkey.key_name

  security_groups = [ aws_security_group.bastions-sg.id ]
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data, tags, volume_tags]
  }
}

resource "aws_security_group" "service-sg" {
  name        = "Service-SG"
  vpc_id      = aws_vpc.VPC-1.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "all"
    security_groups = [aws_security_group.bastions-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = [aws_vpc.VPC-1.cidr_block]
  }
  tags = {
    Name = "bastion-SG"
  }
}

resource "aws_instance" "service" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.nano"
  
  key_name = aws_key_pair.rootkey.key_name

  subnet_id     = "${aws_subnet.SERVICE-1.id}"
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data, tags, volume_tags]
  }
}

resource "aws_security_group" "database-sg" {
  name        = "Database-SG"
  vpc_id      = aws_vpc.VPC-1.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "all"
    security_groups = [ aws_security_group.bastions-sg.id ]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [aws_vpc.VPC-1.cidr_block]
  }
  tags = {
    Name = "database-SG"
  }
}


resource "aws_instance" "database" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.nano"
  key_name      = aws_key_pair.rootkey.key_name
  subnet_id     = "${aws_subnet.DATA-1.id}"
  security_groups = [ aws_security_group.database-sg.id ]
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data, tags, volume_tags]
  }
}

resource "aws_security_group" "api-sg" {
  name        = "Api-SG"
  vpc_id      = aws_vpc.VPC-1.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "all"
    security_groups = [aws_security_group.bastions-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Api-SG"
  }
}


resource "aws_instance" "api" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.nano"
  key_name = aws_key_pair.rootkey.key_name
  subnet_id     = "${aws_subnet.DMZ-1.id}"

  security_groups = [ aws_security_group.api-sg.id ]
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data, tags, volume_tags]
  }
}
