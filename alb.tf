// For ECS
resource "aws_alb" "srdev_alb" {
  name            = "phe-ecs-alb"
  subnets         = tolist(data.aws_subnet_ids.public.ids)
  security_groups = [aws_security_group.ecs_lb_sg.id]

  tags = merge(local.common_tags,
    {
      Name = "phe-ecs-alb"
  })
}

resource "aws_alb_target_group" "alb_tg_1" {
  name        = "phe-ecs-tg-1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.phe_devops_test_vpc.id
  target_type = "ip"
  deregistration_delay = 60


  health_check {
    healthy_threshold   = "2"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "301"
    timeout             = "5"
    path                = var.health_check_path
    unhealthy_threshold = "2"

  }


}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.srdev_alb.id
  port = "80"
  protocol = "HTTP"

   default_action {
    target_group_arn = aws_alb_target_group.alb_tg_1.id
    type = "forward"
  }
//  default_action {
//    type = "redirect"
//
//    redirect {
//      port = "443"
//      protocol = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
}

//resource "aws_alb_listener" "srdev_front_end_ssl" {
//  load_balancer_arn = aws_alb.srdev_alb.id
//  port = "443"
//  protocol = "HTTPS"
//
//  ssl_policy = "ELBSecurityPolicy-2016-08"
//  certificate_arn =  var.cert_arn
//
//
//  default_action {
//    target_group_arn = aws_alb_target_group.alb_tg_1.id
//    type = "forward"
//  }
//}