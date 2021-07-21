data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_subnet_ids" "public" {
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
  vpc_id = aws_vpc.phe_devops_test_vpc.id
}

data "aws_subnet_ids" "private" {
  filter {
    name   = "tag:Type"
    values = ["Private"]
  }
  vpc_id = aws_vpc.phe_devops_test_vpc.id
}