#===========================================================
# VPC
#============================================================
resource "aws_vpc" "vpc" {
    assign_generated_ip6_cidr_block      = false
    cidr_block                           = "10.0.0.0/21"
    enable_dns_hostnames                 = true
    enable_dns_support                   = true
    enable_network_address_usasge_metric = false
    intance_tenancy                      = "default"
    tags = {
        Name    = "${var.project}-vpc"
        Project = var.project
    }
}

#===========================================================
# Subnet 
#============================================================
resource "aws_subnet" "subnet_public1" {
    vpc_id                  = aws_vpc.vpc.id
    availablity_zone        = "ap-northeast-1a"
    cidr_blocks             = "10.0.0.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name      = "{var.project}-subnet-public1"
        Project   = var.project
        Type      = "public"  
    }
}

resource "aws_subnet" "subnet_public2" {
    vpc_id                  = aws_vpc.vpc.id
    availability_zone       = "ap-northeast-1c"
    cidr_blocks             = "10.0.1.0/24"
    map_public_ip_om_launch = true
    tags = {
        Name     = "${var.project}-subnet-public2"
        Project  = var.project
        Type     = "public"
    }
} 

resource "aws_subnet" "subnet_private1" {
    vpc_id                   = aws_vpc.vpc.id
    availablity_zone         = "ap-northeast-1a"
    cidr_blocks              = "10.0.2.0/24"
    map_public_ip_on_launch  = false
    tags = {
        Name     = "${var.project}-subnet-private1"
        Project  = var.Project
        Type     = "private"
    }
}
resource "aws_subnet" "subnet_private2" {
    vpc_id                    = aws_vpc.vpc.id
    availability_zone         = "ap-northeast-1c"
    cidr_blocks               = "10.0.3.0/24"
    map_public_ip_on_launch   = false
    tags = {
        Name                  = "${var.project}-subnet-private2"
        Project               = var.project
        Type                  = "private"
    }
}

#==============================================================
#RouteTable
#==============================================================
#インターネットゲートウェイに向けるルートテーブル
resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name      = "${var.project}-public-rtb"
        Project   = var.project
        Type      = "public"
    }
}

#サブネットへの関連付け
resource "aws_route_table_assosiation" "public_rtb_1a" {
    route_table_id  = aws_route_table.public_rtb.id
    subnet_id       = aws_subnet_subnet_public1.id
}

resource "aws_route_table_assosiation" "public_rtb_1c" {
    route_table_id  = aws_route_table.public_rtb.id
    subnet_id       = aws_subnet_subnet_public2.id
}