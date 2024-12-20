
# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "latest_amzn2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-*"]
  }
  name_regex = "^amzn2-ami-hvm-.*"
}

data "aws_vpc" "selected_vpc" {
  default = true
}

# Data source to select a specific subnet
data "aws_subnet" "selected_subnet" {
  filter {
    name   = "tag:Name"
    # Replace the value with the name of the subnet you want to use
    values = ["tc-inf-net-lab-23220-us-east-1c-services-subnet-APP1"]
  }
}

# Create an SSH Key Pair
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

# Save the private key to a local file
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "vbathini_lab_key.pem"
}

# Create an AWS Key Pair using the public key
resource "aws_key_pair" "generated" {
  key_name   = "vbathini_lab_key_2" # Specify a static name for the key pair
  public_key = tls_private_key.generated.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }

  provisioner "local-exec" {
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }
}

# Data source to fetch existing security group
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    # Replace the value with the name of the security group you want to use
    values = ["tsg-vb-sg"]
  }
  vpc_id = "vpc-95a470f3"
}

# Resource to create a new security group
resource "aws_security_group" "tf-vb-sg" {
  count = length(data.aws_security_group.existing_sg.id) == 0 ? 1 : 0 # FIX: Used '.ids'

  name        = "tsg-vb-sg"
  description = "Allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = "vpc-95a470f3"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance using the generated key pair and selected subnet
module "server" {
  source          = "./modules/ec2_instance"
  instance_type   = "t2.micro"
  ami_id          = data.aws_ami.latest_amzn2.id
  subnet_id       = data.aws_subnet.selected_subnet.id
  key_name        = aws_key_pair.generated.key_name
  security_groups = length(data.aws_security_group.existing_sg.id) == 0 ? [aws_security_group.tf-vb-sg[0].id] : [data.aws_security_group.existing_sg.id]
}
