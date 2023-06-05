#######################################################################################

# LOAD BALANCER INFO

#######################################################################################


#Create ALB
resource "aws_lb" "front" {
  name               = "TeamSequoia"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  enable_deletion_protection = false

  tags = {
    Environment = "front"
  }
}

#Create TG
resource "aws_lb_target_group" "front" {
  name     = "Team-Sequoia-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 45
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
    unhealthy_threshold = 3
  }
}

#resource "aws_lb_target_group_attachment" "attach-app1" {
#  target_group_arn = aws_lb_target_group.front.arn
#  target_id        = aws_instance.main.id
#  port             = 80
#}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}


