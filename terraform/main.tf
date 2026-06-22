resource "aws_key_pair" "devops_key" {
  key_name   = "devops-practical-key"
  public_key = file("${path.module}/devops-practical-key.pub")
}

resource "aws_security_group" "flask_sg" {
  name = "flask-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "flask_server" {
  ami                    = "ami-0f0ce06b5a8a31018"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  tags = {
    Name = "terraform-flask-server"
  }
}
