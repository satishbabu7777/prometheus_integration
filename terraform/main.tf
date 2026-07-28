############################################
# VPC
############################################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "booking-vpc"
  }
}

############################################
# Internet Gateway
############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "booking-igw"
  }
}

############################################
# Public Subnet
############################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "booking-public-subnet"
  }
}

############################################
# Route Table
############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "booking-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

############################################
# Security Group
############################################

resource "aws_security_group" "booking_sg" {
  name   = "booking-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spring Boot"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "booking-sg"
  }
}

############################################
# IAM Role for EC2
############################################

resource "aws_iam_role" "ec2_role" {
  name = "booking-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "booking-instance-profile"
  role = aws_iam_role.ec2_role.name
}

############################################
# EC2 Instance
############################################

resource "aws_instance" "booking_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.booking_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "booking-server"
  }
}

############################################
# Amazon ECR
############################################

resource "aws_ecr_repository" "booking" {
  name = "booking-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

############################################
# RDS Subnet Group
############################################

resource "aws_db_subnet_group" "booking" {
  name       = "booking-db-subnet-group"
  subnet_ids = [aws_subnet.public.id]

  tags = {
    Name = "booking-db-subnet-group"
  }
}

############################################
# PostgreSQL RDS
############################################

resource "aws_db_instance" "booking" {

  identifier             = "booking-db"

  engine                 = "postgres"
  engine_version         = "16"

  instance_class         = var.db_instance_class

  allocated_storage      = 20

  db_name                = "bookingdb"

  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.booking.name

  vpc_security_group_ids = [aws_security_group.booking_sg.id]

  publicly_accessible    = true

  skip_final_snapshot    = true

  tags = {
    Name = "booking-postgres"
  }
}