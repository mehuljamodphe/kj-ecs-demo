locals {
  full_name             = "phe-devops-test"
  common_tags = {
    Application = "ecs"
    Creator     = "Terraform"
    Environment = "Test"
  }
}