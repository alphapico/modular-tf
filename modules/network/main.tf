resource "aws_vpc" "charonium-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "charonium-public-subnet-1" {
  vpc_id            = aws_vpc.charonium-vpc.id
  cidr_block        = var.subnet_cidr_block_1
  availability_zone = var.avail_zone_1

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-public-subnet-1"
  }
}

resource "aws_subnet" "charonium-public-subnet-2" {
  vpc_id            = aws_vpc.charonium-vpc.id
  cidr_block        = var.subnet_cidr_block_2
  availability_zone = var.avail_zone_2

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-public-subnet-2"
  }
}

resource "aws_internet_gateway" "charonium-igw" {
  vpc_id = aws_vpc.charonium-vpc.id

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-igw"
  }
}

resource "aws_route_table" "charonium-public-rtb" {
  vpc_id = aws_vpc.charonium-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.charonium-igw.id
  }

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-public-rtb"
  }
}

resource "aws_route_table_association" "charonium-asc-rtb-1" {
  subnet_id      = aws_subnet.charonium-public-subnet-1.id
  route_table_id = aws_route_table.charonium-public-rtb.id
}

resource "aws_route_table_association" "charonium-asc-rtb-2" {
  subnet_id      = aws_subnet.charonium-public-subnet-2.id
  route_table_id = aws_route_table.charonium-public-rtb.id
}

resource "aws_security_group" "charonium-sg" {
  name        = "${var.app_name}-${var.env_prefix}-sg"
  description = "Default security group for ${var.app_name}-${var.env_prefix}"
  vpc_id      = aws_vpc.charonium-vpc.id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.postgres_port
    to_port   = var.postgres_port
    protocol  = "tcp"
    self      = true
    # security_groups = [aws_security_group.charonium-sg.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-sg"
  }
}
