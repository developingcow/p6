variable "local_ip" {
  type        = string
  description = "local ip that is allowed to ssh into ec2 instances created"
  default     = "1.1.1.1/32"
}

variable "ssh_key" {
  type        = string
  description = "ssh key name that is used to ssh into ec2 instances created"
  default     = "ssh"
}

variable "aws_ami" {
  type    = string
  default = "ami-0c7217cdde317cfec"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.2.0/24"
# }

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat.id
#   }
# }

# resource "aws_route_table_association" "private_rt_assoc" {
#   subnet_id      = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private_rt.id
# }

resource "aws_security_group" "public_sg" {
  name   = "public_sg"
  vpc_id = aws_vpc.main.id

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

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.local_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name   = "private_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.local_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet.id

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_instance" "jenkins_instance" {
#   ami                    = "ami-0c7217cdde317cfec"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private_subnet.id
#   vpc_security_group_ids = [aws_security_group.private_sg.id]
#   #   user_data              = file("db-user-data.sh")
#   key_name = var.ssh_key

#   private_ip = "10.0.2.15" # static private ip

#   depends_on = [aws_nat_gateway.nat]
# }

resource "aws_instance" "jenkins_instance_public" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.large"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  user_data              = file("jenkins-user-data.sh")
  key_name               = var.ssh_key

  depends_on = [aws_internet_gateway.igw]
  #   depends_on = [aws_internet_gateway.igw, aws_instance.jenkins_instance]
}

resource "aws_instance" "server_instance_public" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  user_data              = file("server-user-data.sh")
  key_name               = var.ssh_key

  private_ip = "10.0.1.155" # static private ip

  depends_on = [aws_internet_gateway.igw]
  #   depends_on = [aws_internet_gateway.igw, aws_instance.jenkins_instance]
}
