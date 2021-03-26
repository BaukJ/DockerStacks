resource "aws_key_pair" "devops" {
  key_name   = "devops"
  public_key = file(var.public_key_path)
  tags       = local.tags
}


resource "aws_instance" "masters" {
  count                  = local.multi_node ? var.master_count : 1
  ami                    = data.aws_ami.aws_linux.id
  availability_zone      = data.aws_availability_zones.available.names[count.index] # TODO use a modulus
  instance_type          = var.master_type
  key_name               = "devops"
  vpc_security_group_ids = [aws_security_group.swarm.id]
  tags = merge(local.tags, {
    Name = "DockerMaster_${count.index}"
    Role = "DockerMaster"
  })
}
resource "aws_eip" "master" {
  vpc = true
  instance  = aws_instance.masters[0].id
}

resource "aws_lb" "masters" {
  name               = "DockerLoadBalancer"
  count              = local.multi_node ? 1 : 0
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_instance.masters.*.subnet_id
  security_groups    = [aws_security_group.lb[0].id]
  tags               = local.tags
}
resource "aws_lb_target_group" "masters" {
  name        = "DockerLBTargetGroup"
  count       = local.multi_node ? 1 : 0
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"
  tags        = local.tags
}
resource "aws_lb_target_group_attachment" "masters" {
  count            = local.multi_node ? length(aws_instance.masters) : 0
  target_group_arn = aws_lb_target_group.masters[0].arn
  target_id        = aws_instance.masters[count.index].id
  port             = 80
}
resource "aws_security_group" "lb" {
  name  = "lb"
  count = local.multi_node ? 1 : 0
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = var.exposed_ports
    content {
      from_port   = try(ingress.value.from_port, ingress.key)
      to_port     = try(ingress.value.to_port, ingress.key)
      protocol    = try(ingress.value.protocol, "tcp")
      cidr_blocks = try(ingress.value.cidr_blocks, ["0.0.0.0/0"])
    }
  }
  tags = local.tags
}
resource "aws_security_group" "swarm" {
  name = "swarm"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
    cidr_blocks = [var.ssh_cidr]
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = var.exposed_ports
    content {
      from_port   = try(ingress.value.from_port, ingress.key)
      to_port     = try(ingress.value.to_port, ingress.key)
      protocol    = try(ingress.value.protocol, "tcp")
      cidr_blocks = try(ingress.value.cidr_blocks, ["0.0.0.0/0"])
    }
  }
  tags = local.tags
}
