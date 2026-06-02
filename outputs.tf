output "aws_app_url" {
  description = "Calculator URL on AWS (null if disabled)."
  value       = var.enable_aws ? module.aws_app[0].app_url : null
}

output "aws_public_ip" {
  description = "AWS EC2 public IP."
  value       = var.enable_aws ? module.aws_app[0].public_ip : null
}

# When using multi_cloud.tf, also add outputs from outputs.multi.tf.example
