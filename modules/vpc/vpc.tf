# Module: aws_vpc
# The purpose of this module is to represent an AWS VPC

variable "owner" {
  default = []
}

variable "project" {
  default = []
}

output "vpc_id" {
  value = aws_vpc.main.tags_all
}

output "subnet_ids" {
  value = [
    "${aws_subnet.public1.id}", 
    "${aws_subnet.public2.id}", 
    "${aws_subnet.public3.id}"
  ]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name  = "${var.project}-vpc"
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "${var.project}-igw"
    Owner = var.owner
  }
  depends_on = [aws_subnet.public1]
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name  = "${var.project} public 1"
    Owner = var.owner
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name  = "${var.project} public 2"
    Owner = var.owner
  }
}

# Added public subnet #3 
resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name  = "${var.project} public 3"
    Owner = var.owner
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name  = "${var.project} private 1"
    Owner = var.owner
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"

  tags = {
    Name  = "${var.project} private 2"
    Owner = var.owner
  }
}

# Added private subnet #3
resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"

  tags = {
    Name  = "${var.project} private 3"
    Owner = var.owner
  }
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "eip1" {
  vpc      = true

  tags = {
    Name  = "${var.project} eip 1"
    Owner = var.owner
  }
}

resource "aws_nat_gateway" "natgw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name  = "${var.project} nat gateway 1"
    Owner = var.owner
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name  = "${var.project} public route table"
    Owner = var.owner
  }
}

# Routing Table Associations for public subnets 1-3
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_assoc_3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw1.id
  }

  tags = {
    Name  = "${var.project} private route table"
    Owner = var.owner
  }
}

# Routing Table Associations for private subnets 1-3
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_assoc_3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private_route_table.id
}
