# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "ecs_lb_sg" {
  name        = "app-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      =  aws_vpc.phe_devops_test_vpc.id

  ingress {
	protocol    = "tcp"
	from_port   = 80
	to_port     = 80
	cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
	protocol    = "tcp"
	from_port   = 443
	to_port     = 443
	cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
	protocol    = "-1"
	from_port   = 0
	to_port     = 0
	cidr_blocks = ["0.0.0.0/0"]
  }
}


# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "srdev-app-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.phe_devops_test_vpc.id

  ingress {
	protocol    = "tcp"
	from_port   = 80
	to_port     = 80
	security_groups = [aws_security_group.ecs_lb_sg.id]
  }
  ingress {
	protocol    = "tcp"
	from_port   = 443
	to_port     = 443
	security_groups = [aws_security_group.ecs_lb_sg.id]
  }
  egress {
	protocol    = "-1"
	from_port   = 0
	to_port     = 0
	cidr_blocks = ["0.0.0.0/0"]
  }
}