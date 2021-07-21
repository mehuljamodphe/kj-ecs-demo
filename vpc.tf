
resource "aws_vpc" "phe_devops_test_vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "phe-devops-test-vpc"
  }
}

resource "aws_subnet" "public_1" {
  availability_zone       = "eu-west-3a"
  cidr_block              = "80.10.10.0/24"
  vpc_id                  = aws_vpc.phe_devops_test_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "phe-devops-test-public-1"
    Type = "Public"
  }

}

resource "aws_subnet" "public_2" {
  availability_zone       = "eu-west-3b"
  cidr_block              = "80.10.20.0/24"
  vpc_id                  = aws_vpc.phe_devops_test_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "phe-devops-test-public-2"
    Type = "Public"
  }

}

resource "aws_subnet" "private_1" {
  availability_zone       = "eu-west-3a"
  cidr_block              = "80.10.30.0/24"
  vpc_id                  = aws_vpc.phe_devops_test_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "phe-devops-test-private-1"
    Type = "Private"
  }

}

resource "aws_subnet" "private_2" {
  availability_zone       = "eu-west-3b"
  cidr_block              = "80.10.40.0/24"
  vpc_id                  = aws_vpc.phe_devops_test_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "phe-devops-test-private-2"
    Type = "Private"
  }

}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.phe_devops_test_vpc.id

  tags = {
    Name = "phe-devops-test-ig"
  }
}

# Creating an Route Table for the public subnet!
resource "aws_route_table" "Public-Subnet-RT" {
  depends_on = [
    aws_vpc.phe_devops_test_vpc,
    aws_internet_gateway.ig
  ]

   # VPC ID
  vpc_id = aws_vpc.phe_devops_test_vpc.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}

# Creating a resource for the Route Table Association!
resource "aws_route_table_association" "RT-IG-Association" {

  depends_on = [
    aws_vpc.phe_devops_test_vpc,
    aws_subnet.public_1,
    aws_route_table.Public-Subnet-RT
  ]

# Public Subnet ID
  subnet_id      = aws_subnet.public_1.id

#  Route Table ID
  route_table_id = aws_route_table.Public-Subnet-RT.id
}

resource "aws_route_table_association" "RT-IG-Association-2" {

  depends_on = [
    aws_vpc.phe_devops_test_vpc,
    aws_subnet.public_2,
    aws_route_table.Public-Subnet-RT
  ]

# Public Subnet ID
  subnet_id      = aws_subnet.public_2.id

#  Route Table ID
  route_table_id = aws_route_table.Public-Subnet-RT.id
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
    aws_route_table_association.RT-IG-Association
  ]
  vpc = true
}

# Creating a NAT Gateway!
resource "aws_nat_gateway" "NAT_GATEWAY" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id

  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public_1.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}

# Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "NAT-Gateway-RT" {
  depends_on = [
    aws_nat_gateway.NAT_GATEWAY
  ]

  vpc_id = aws_vpc.phe_devops_test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

resource "aws_route_table_association" "RT-NAT-Association-1" {

  depends_on = [
    aws_vpc.phe_devops_test_vpc,
    aws_subnet.private_1,
    aws_route_table.NAT-Gateway-RT
  ]

# Public Subnet ID
  subnet_id      = aws_subnet.private_1.id

#  Route Table ID
  route_table_id = aws_route_table.NAT-Gateway-RT.id
}

resource "aws_route_table_association" "RT-NAT-Association-2" {

  depends_on = [
    aws_vpc.phe_devops_test_vpc,
    aws_subnet.private_2,
    aws_route_table.NAT-Gateway-RT
  ]

# Public Subnet ID
  subnet_id      = aws_subnet.private_2.id

#  Route Table ID
  route_table_id = aws_route_table.NAT-Gateway-RT.id
}