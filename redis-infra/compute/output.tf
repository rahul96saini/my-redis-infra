output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "redis_instance_ids" {
  value = aws_instance.redis_nodes[*].id
}