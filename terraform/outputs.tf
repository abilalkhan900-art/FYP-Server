# --------------------
# Terraform Outputs
# --------------------
output "client_private_ip" {
  value       = aws_instance.client_vm.private_ip
  description = "Private IP of the client EC2 instance"
}

output "client_public_ip" {
  value       = aws_instance.client_vm.public_ip
  description = "Public IP of the client EC2 instance"
}

output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "VPC ID of the client network"
}
