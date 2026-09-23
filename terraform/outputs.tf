output "public_ip" {
  value = aws_instance.flask_server.public_ip
}

output "instance_id" {
  value = aws_instance.flask_server.id
}
