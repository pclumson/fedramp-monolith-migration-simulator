terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-gov-west-1" # GovCloud Region
  profile = "fedramp-prod"
}

# 1. VPC & Networking (Isolated for FedRAMP)
resource "aws_vpc" "fed_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name        = "FedRAMP-High-VPC"
    Compliance  = "FedRAMP-High"
  }
}

# 2. ECS Cluster (Where the Microservices run)
resource "aws_ecs_cluster" "main" {
  name = "fedramp-migration-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# 3. Application Load Balancer (The Traffic Router)
resource "aws_lb" "app_lb" {
  name               = "fedramp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# 4. Security Group (Least Privilege)
resource "aws_security_group" "app_sg" {
  name        = "fedramp-app-sg"
  vpc_id      = aws_vpc.fed_vpc.id
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Internal only
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. RDS (Encrypted Database)
resource "aws_db_instance" "postgres" {
  identifier     = "fedramp-db"
  engine         = "postgres"
  engine_version = "14.7"
  instance_class = "db.t3.medium"
  
  allocated_storage     = 20
  storage_encrypted     = true # REQUIRED for FedRAMP
  kms_key_id            = aws_kms_key.db_key.arn
  
  db_name  = "migration_db"
  username = "admin"
  password = var.db_password # Injected via Secrets Manager in real prod
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
}

# 6. KMS Key for Encryption
resource "aws_kms_key" "db_key" {
  description             = "FedRAMP High Encryption Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}
