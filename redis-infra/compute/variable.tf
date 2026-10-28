variable "public_subnet_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "key_name" {}