resource "aws_ecs_cluster" "phe_test_cluster" {
  name = "phe_test_cluster"
}

data "template_file" "app" {
  template = file("./templates/ecs/ecs.json.tpl")

  vars = {
    app_name              =   var.app_name
    app_image             =   var.app_image
    app_port              =   var.app_port
    fargate_cpu           =   var.fargate_cpu
    fargate_memory        =   var.fargate_memory
    aws_region            =   var.AWS_REGION
    db_host               =   var.database_host
    db_name               =   var.database_name
    db_user               =   var.database_username
    db_pass               =   var.database_password
  }
}

resource "aws_ecs_task_definition" "app_task_def" {
  family                   = "app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.app.rendered
}

resource "aws_ecs_service" "sr_dev_app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.phe_test_cluster.id
  task_definition = aws_ecs_task_definition.app_task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = tolist(data.aws_subnet_ids.public.ids)
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_tg_1.id
    container_name   = var.app_name
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = merge(local.common_tags,
  {
      Name = "phe-test-cluster"
  })
}