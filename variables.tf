variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-3"
}

variable "VPC_CIDR" {}


variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "pheECSTaskExecutionRole"
}

variable "app_name" {
  description = "Name of the container"
  default     = "phe-app"
}
variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "562729601838.dkr.ecr.eu-west-3.amazonaws.com/phe-devops-ecr:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_grace_period_seconds" {
  default = 90
}


variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "database_host" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}

variable "cert_arn" {
  default = "arn:aws:acm:eu-west-2:636728427214:certificate/f4faa036-5a5c-4f02-a770-5d3f49579fac"
  description = "certificate ARN [example : arn:aws:acm:eu-west-2:636728427214:certificate/47c353f2-f704-4d71-8ed9-fb63ab238449]"
}
