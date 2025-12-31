# Key pair
resource "aws_key_pair" "my_key" {
  key_name   = "TF-key"
  public_key = file("/home/ubuntu/terraform/terra-key-ec2.pub")

}

# VPC & SG
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "my_security_group" {
  name        = "automate_sg"
  description = "This will add a TF genrated Security Group"
  vpc_id      = aws_default_vpc.default.id #interpolation

  tags = {
    Name = "Created_by_TF"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "This will allow traffic on por 22"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "This will allow traffic on port 80"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  description       = "This will allow all outbond traffic"
}

# Ec2 instance
resource "aws_instance" "my_instance" {
  for_each = tomap({
    Streaming-1 = "t2.micro"
    Streaming-2 = "t2.medium"
  }) # meta argument

  depends_on = [aws_default_vpc.default, aws_security_group.my_security_group, aws_key_pair.my_key]

  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id
  user_data       = file("install_nginx.sh")

  root_block_device {
    volume_size = var.ec2_root_volume_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }

}

resource "aws_instance" "my_instance-new" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.medium"

  key_name  = "KeyPair_1"
  subnet_id = "subnet-0782b79778b517554"

  vpc_security_group_ids = [
    "sg-00607447040dd6c79"
  ]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "ubuntu_server_k8s_terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}
