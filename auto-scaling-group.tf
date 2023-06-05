
# Ec2 Launch configuration
resource "aws_launch_configuration" "dino-launchconfig" {
  name_prefix      = "dino-launchconfig"
  image_id         = "ami-0bef6cc322bfff646"
  instance_type    = "t3.micro"
  security_groups  = [aws_security_group.main.id]
  user_data        = file("user.sh")

  # This block tells Terraform to create the new version before destroying the original to avoid any service interruptions.
  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "dino-autoscaling" {
  name                    = "${aws_launch_configuration.dino-launchconfig.name}-asg"
  vpc_zone_identifier     = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  launch_configuration    = aws_launch_configuration.dino-launchconfig.name
  desired_capacity        = 2
  min_size                = 1
  max_size                = 2
  target_group_arns       = [aws_lb_target_group.front.arn]
  health_check_grace_period = 300
  health_check_type       = "EC2"
  force_delete            = true

  tags = [
    {
      key                 = "Name"
      value               = "Sequoia-EC2"
      propagate_at_launch = true
    }
  ]
}
