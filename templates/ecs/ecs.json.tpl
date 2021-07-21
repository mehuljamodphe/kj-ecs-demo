[
  {
    "name": "${app_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "phe-ecs-lg",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "environment": [
        {
            "name" : "DATABASE_HOSTADDR",
            "value" : "${db_host}"
        },
        {
            "name" : "DATABASE_NAME",
            "value" : "${db_name}"
        },
        {
            "name" : "DATABASE_USERNAME",
            "value" : "${db_user}"
        },
        {
            "name" : "DATABASE_PASS",
            "value" : "${db_pass}"
        }
    ],
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]