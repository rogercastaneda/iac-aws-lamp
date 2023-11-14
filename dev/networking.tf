resource "aws_security_group" "web" {
  name = "SG-${local.env}"

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

  ingress {
    from_port   = 2049
    to_port     = 2049
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

resource "aws_security_group" "db" {
  name = "db-sg-${local.env}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
}
data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

# Subnets
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name  = "Default subnet for us-east-1a"
    Scope = "Default"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    Name  = "Default subnet for us-east-1b"
    Scope = "Default"
  }
}
resource "aws_default_subnet" "default_az3" {
  availability_zone = "us-east-1c"

  tags = {
    Name  = "Default subnet for us-east-1c"
    Scope = "Default"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.48.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"


  tags = {
    Name = "Subnet public 1 - ${local.env}"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.56.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Subnet public 2 - ${local.env}"
  }
}
resource "aws_subnet" "public-3" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.64.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "Subnet - public 3 - ${local.env}"
  }
}
resource "aws_subnet" "private-1" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.72.0/21"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Subnet - private 1 - ${local.env}"
  }
}
resource "aws_subnet" "private-2" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.80.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Subnet - private 2 - ${local.env}"
  }
}
resource "aws_subnet" "private-3" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.88.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "Subnet - private 3 - ${local.env}"
  }
}


