output "instance_id" {
  description = "ID da instancia EC2"
  value       = aws_instance.network_tools.id
}

output "instance_public_ip" {
  description = "IP publico da instancia"
  value       = aws_instance.network_tools.public_ip
}

output "instance_public_dns" {
  description = "DNS publico da instancia"
  value       = aws_instance.network_tools.public_dns
}

output "ssh_command" {
  description = "Comando SSH para conectar na instancia"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.network_tools.public_ip}"
}
