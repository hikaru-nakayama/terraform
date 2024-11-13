resource "aws_vpc" "isucon" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "isucon"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.isucon.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
}

resource "aws_internet_gateway" "isucon" {
    vpc_id = aws_vpc.isucon.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.isucon.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.isucon.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "isucon" {
  name = "isucon"
  vpc_id = aws_vpc.isucon.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "isucon"
  }
}

resource "aws_instance" "isucon1" {
  ami = "ami-006d211cb716fe8a0"
  instance_type = "c6i.large"
  key_name      = "isucon20241113"
  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.isucon.id]

  tags = {
    Name = "hikaru-ec2"
  }
}

resource "aws_instance" "isucon2" {
  ami = "ami-006d211cb716fe8a0"
  instance_type = "c6i.large"
  key_name      = "isucon20241113"
  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.isucon.id]

  tags = {
    Name = "hikaru-ec2"
  }
}
