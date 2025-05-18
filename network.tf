# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform

#------------------------------------
# VPC
#------------------------------------
resource "aws_vpc" "cloudtech_vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.0.0.0/21"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {
    Name    = "${var.project}-vpc"
    Project = var.project
  }
}
#------------------------------------
# Subnet
#------------------------------------
resource "aws_subnet" "cloudtech_subnet_public1" {
  vpc_id = aws_vpc.cloudtech_vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-subnet-public1"
    Project = var.project
    Type    = "public"
  }
}

resource "aws_subnet" "cloudtech_subnet_public2" {
  vpc_id            = aws_vpc.cloudtech_vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-subnet-public2"
    Project = var.project
    Type    = "public"
  }
}

resource "aws_subnet" "cloudtech_subnet_private1" {
  vpc_id            = aws_vpc.cloudtech_vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-subnet-private1"
    Project = var.project
    Type    = "private"
  }
}

resource "aws_subnet" "cloudtech_subnet_private2" {
  vpc_id            = aws_vpc.cloudtech_vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-subnet-private2"
    Project = var.project
    Type    = "private"
  }
}

#------------------------------------
# RouteTable
#------------------------------------
# インターネットゲートウェイに向けるルートテーブル
resource "aws_route_table" "cloudtech_public_rtb" {
  vpc_id = aws_vpc.cloudtech_vpc.id
  tags = {
    Name    = "${var.project}-public-rtb"
    Project = var.project
    Type    = "public"
  }
}

# サブネットへの関連付け
resource "aws_route_table_association" "public_rtb_1a" {
  route_table_id = aws_route_table.cloudtech_public_rtb.id
  subnet_id      = aws_subnet.cloudtech_subnet_public1.id
}

resource "aws_route_table_association" "public_rtb_1c" {
  route_table_id = aws_route_table.cloudtech_public_rtb.id
  subnet_id      = aws_subnet.cloudtech_subnet_public2.id
}

# local内に向けるルートテーブル
resource "aws_route_table" "cloudtech_private_rtb" {
  vpc_id = aws_vpc.cloudtech_vpc.id
  tags = {
    Name    = "${var.project}-private-rtb"
    Project = var.project
    Type    = "private"
  }
}
resource "aws_route_table_association" "private_rtb_1a" {
  route_table_id = aws_route_table.cloudtech_private_rtb.id
  subnet_id      = aws_subnet.cloudtech_subnet_private1.id
}

resource "aws_route_table_association" "private_rtb_1c" {
  route_table_id = aws_route_table.cloudtech_private_rtb.id
  subnet_id      = aws_subnet.cloudtech_subnet_private2.id
}

#------------------------------------
# Internet Gateway
#------------------------------------
resource "aws_internet_gateway" "cloudtech_igw" {
  vpc_id = aws_vpc.cloudtech_vpc.id
  tags = {
    Name    = "${var.project}-igw"
    Project = var.project
  }
}
# Internet Gatewayをどのルートテーブルに対して指定するのか
resource "aws_route" "puclic_rtb_igw_route" {
  route_table_id         = aws_route_table.cloudtech_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloudtech_igw.id
}