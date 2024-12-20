resource "aws_instance" "general_instance" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  availability_zone = "us-east-1c"
  security_groups   = var.security_groups
  tags = {
    Name = "general_instance"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }
}
