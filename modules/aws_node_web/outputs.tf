output "app_url" {
  description = "URL to open the calculator in a browser."
  value       = "http://${aws_instance.this.public_dns}"
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "cloud" {
  description = "Cloud provider name."
  value       = "aws"
}
