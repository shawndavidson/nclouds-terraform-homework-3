# Module: aws_vpc
# The purpose of this module is to represent an AWS VPC

resource "aws_vpc" "main" {
  cidr_block    = var.cidr_block

  tags = {
    Name        = "${var.project}-vpc"
    Owner       = var.owner
    Environment = var.environment
    DateTime    = var.datetime
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-igw"
    Owner       = var.owner
    Environment = var.environment
    DateTime    = var.datetime
  }
  depends_on = [aws_subnet.public[0]]
}

resource "aws_subnet" "public" {
  count      = var.num_availability_zones
  vpc_id     = aws_vpc.main.id
  cidr_block = "${cidrsubnet(var.cidr_block, 8, count.index)}"

  tags = {
    Name        = "${var.project} public ${count.index}"
    Owner       = var.owner
    Environment = var.environment
    DateTime    = var.datetime
  }
}

resource "aws_subnet" "private" {
  count      = var.num_availability_zones
  vpc_id     = aws_vpc.main.id
  cidr_block = "${cidrsubnet(var.cidr_block, 8, count.index+var.num_availability_zones)}"

  tags = {
    Name  = "${var.project} private ${count.index}"
    Owner = var.owner
    Environment = var.environment
    DateTime    = var.datetime
  }
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "eip1" {
  vpc      = true

  tags = {
    Name  = "${var.project} eip 1"
    Owner = var.owner
    Environment = var.environment
    DateTime    = var.datetime
  }
}

resource "aws_nat_gateway" "natgw1" {
  allocation_id = aws_eip.eip1.id

  # Place the NAT Gateway in the first public subnet
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name  = "${var.project} nat gateway 1"
    Owner = var.owner
    Environment = var.environment
    DateTime    = var.datetime
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
    Environment = var.environment
    DateTime    = var.datetime
  }
}

# Routing Table Associations for public subnets 
resource "aws_route_table_association" "public_assoc" {
  count          = var.num_availability_zones
  subnet_id      = aws_subnet.public[count.index].id
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
    Environment = var.environment
    DateTime    = var.datetime
 }
}

# Routing Table Associations for private subnets 
resource "aws_route_table_association" "private_assoc" {
  count          = var.num_availability_zones
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

