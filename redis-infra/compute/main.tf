# Bastion Host in Public Subnet
resource "aws_instance" "bastion" {
  ami                    = "ami-053b12be3c279a9c7" # Ubuntu 22.04 LTS for ap-south-1
  instance_type          = "t3.micro"
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "redis-bastion-host"
  }
}

# 3 Redis Nodes in Private Subnets (Tagged for Ansible Dynamic Inventory)
resource "aws_instance" "redis_nodes" {
  count                  = 3
  ami                    = "ami-053b12be3c279a9c7"
  instance_type          = "t3.small"
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = "redis-node-${count.index + 1}"
    Environment = "production"
    Role        = "redis-node"
  }
}