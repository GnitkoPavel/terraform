data "aws_availability_zones" "available" {}

resource "random_id" "tf_vpc_id" {
  byte_length = 2
}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf_vpc-${random_id.tf_vpc_id.dec}"
  }
}

resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }

  tags = {
    Name = "tf_public_rt-${random_id.tf_vpc_id.dec}"
  }
}

resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id = aws_vpc.tf_vpc.default_route_table_id

  tags = {
    Name = "tf_private_rt-${random_id.tf_vpc_id.dec}"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  count                   = 3
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.tf_vpc.id
  map_public_ip_on_launch = true
  #availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "tf_public-${count.index + 1}-${random_id.tf_vpc_id.dec}"
  }
}

resource "aws_route_table_association" "tf_public_assoc" {
  count          = length(aws_subnet.tf_public_subnet)
  subnet_id      = aws_subnet.tf_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.tf_public_rt.id
}

resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg-${random_id.tf_vpc_id.dec}"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.tf_vpc.id

  #HTTP
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [var.accessip]
  }

  #HTTPS
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = [var.accessip]
  }

  #SSH
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.accessip]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
