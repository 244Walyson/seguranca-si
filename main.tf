terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "terraform"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-network-tools"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-network-tools"
  }
}

# Subnet pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-public-network-tools"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rt-public-network-tools"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "network_tools" {
  name        = "network-tools-sg"
  description = "Security group para instancia com ferramentas de rede"
  vpc_id      = aws_vpc.main.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # ICMP (ping)
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saída irrestrita
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-network-tools"
  }
}

# Key Pair
resource "aws_key_pair" "network_tools" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))
}

# EC2 Instance
resource "aws_instance" "network_tools" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.create_key_pair ? aws_key_pair.network_tools[0].key_name : var.existing_key_name
  vpc_security_group_ids = [aws_security_group.network_tools.id]
  subnet_id              = aws_subnet.public.id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y tcpdump nmap traceroute telnet nc bind-utils iperf3 mtr
              EOF

  tags = {
    Name = "ec2-network-tools"
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
