resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "example"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
}

resource "aws_internet_gateway" "example" {
    vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "example" {
  name = "example"
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group_rule" "ingress_example" {
  type = "ingress"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "egress_example" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

resource "aws_instance" "example" {
  ami = "ami-09a81b370b76de6a2"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "hikaru-ec2"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}