locals {
  shared_files = "${path.module}/../shared/files"
}

resource "aws_security_group" "web" {
  name        = var.security_group_name
  description = "Allow HTTP and SSH"

  ingress {
    description = "HTTP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data_replace_on_change = var.user_data_replace_on_change
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    app_port       = var.app_port
    index_html_b64 = filebase64("${local.shared_files}/index.html")
    server_js_b64  = filebase64("${local.shared_files}/server.js")
  })

  tags = {
    Name = var.instance_name
  }
}
