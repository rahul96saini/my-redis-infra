# Public Subnet for Bastion Host
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = { Name = "redis-public-subnet" }
}

# Private Subnet 1 (AZ: ap-south-1a)
resource "aws_subnet" "private_1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = { Name = "redis-private-1a" }
}

# Private Subnet 2 (AZ: ap-south-1b)
resource "aws_subnet" "private_2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = { Name = "redis-private-1b" }
}

# Private Subnet 3 (AZ: ap-south-1c)
resource "aws_subnet" "private_3" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1c"

  tags = { Name = "redis-private-1c" }
}