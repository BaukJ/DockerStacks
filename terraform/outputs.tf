output "meta" {
  value = {
    ami        = "${data.aws_ami.aws_linux.id} ${data.aws_ami.aws_linux.description}"
    lb_ip      = local.multi_node ? aws_lb.masters[0].dns_name : "NOT RUNNING IN MULTI-NODE CLUSTER"
    ec2 = [for ec2 in aws_instance.masters : {
      id        = ec2.id
      public_ip = ec2.public_ip
      instance_type = ec2.instance_type
    }]
  }
}
