provider "aws" {
  region = "ap-south-1"
  # Input of User Credientials(Programatic)
  access_key = var.accesskey
  secret_key = var.secretkey
}
# For Creating Security Group(NEW)
resource "aws_security_group" "lab-ssh-http" {
  name        = "lab-ssh-http"
  description = "allowing ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
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
# For creating EC2 Instance Ubuntu
resource "aws_instance" "lab" {
  ami                    = "ami-0db0b3ab7df22e366"
  availability_zone      = "ap-south-1a"
  instance_type          = "t2.micro"
  key_name               = var.keyname
  vpc_security_group_ids = ["${aws_security_group.lab-ssh-http.name}"]

  tags = {
    Name = "lab-server"
  }
}
# For Creating EBS Volume
resource "aws_ebs_volume" "lab-vol" {
  availability_zone = "ap-south-1a"
  size              = 1
  tags = {
    Name = "lab-volume"
  }
}
# Attaching the Newly created EBS with EC2 Instance
resource "aws_volume_attachment" "lab-vol" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.lab-vol.id
  instance_id = aws_instance.lab.id
}
