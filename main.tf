provider "aws" {
    profile = "acg"
    region  = "us-east-1"
}

data "aws_ami" "aws_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
output "ami" {
  value = data.aws_ami.aws_linux
}


resource "aws_instance" "main" {
  ami           = data.aws_ami.aws_linux.id
  #instance_type = "m4.large"
  instance_type = "t2.micro"
  tags          = {
    Name = "Jakub.Jasko Training"
    Owner = "Jakub.Jasko"
    Reason = "Training"
  }
}
output "ec2" {
  value = aws_instance.main
}

