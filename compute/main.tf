data "aws_ami" "server_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

data "template_file" "userdata" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    security_group = var.security_group
  }
}

resource "aws_key_pair" "master-key" {
  key_name   = var.key_name
  public_key = var.public_key_path
}

resource "aws_launch_configuration" "tf_LC" {
  name_prefix          = "tf_LT-"
  image_id      = data.aws_ami.server_ami.id
  instance_type = var.instance_type
  security_groups = [var.security_group]
  associate_public_ip_address = true
  key_name      = aws_key_pair.master-key.id
  enable_monitoring = false
  user_data = data.template_file.userdata.rendered

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }
}

data "aws_availability_zones" "azs" {
  state    = "available"
}

resource "aws_autoscaling_group" "tf_ASG" {
  name = "tf_ASG"
  max_size         = 1
  min_size         = 1
  desired_capacity = 1
  vpc_zone_identifier = var.subnets
  launch_configuration = aws_launch_configuration.tf_LC.id
  load_balancers = [aws_elb.example.name]
  health_check_type         = "ELB"
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "tf_ASG"
  }
}

resource "aws_elb" "example" {
  name = "tf-AWS-ELB"
  security_groups = [var.security_group]
  #availability_zones = var.availability_zones # for instance ec2
  subnets = var.subnets

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/healthy.html"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
  tags = {
    Name = "tf-terraform-elb"
  }
}