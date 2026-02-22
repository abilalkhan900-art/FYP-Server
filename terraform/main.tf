# --------------------
# VPC
# --------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "client-capstone-vpc"
  }
}

# --------------------
# Subnet
# --------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"       # Different subnet from server
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"       # Supported AZ for t3.micro

  tags = {
    Name = "client-public-subnet"
  }
}

# --------------------
# Internet Gateway
# --------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# --------------------
# Route Table
# --------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# --------------------
# Security Group
# --------------------
resource "aws_security_group" "client_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3020
    to_port     = 3020
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------
# Get Latest Ubuntu AMI
# --------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# --------------------
# EC2 Instance - Client
# --------------------
resource "aws_instance" "client_vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"                # Free Tier eligible
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.client_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  # IMPORTANT: Do NOT specify availability_zone here
  # The subnet already fixes it to a supported AZ

  tags = {
    Name = "client-vm"
  }
}
