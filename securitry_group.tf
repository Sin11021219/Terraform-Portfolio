#-------------------------------------
# EC2 SSM Security Group
#-------------------------------------
resource "aws_security_group" "cloudtech_ec2_ssm_sg" {
  name        = "${var.project}-ec2-ssm-sg"
  description = "SystemsManager SessionManager"
  vpc_id      = aws_vpc.cloudtech_vpc.id

  tags = {
    Name    = "${var.project}-ec2-ssm-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.cloudtech_ec2_ssm_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  cidr_blocks       = ["0.0.0.0/0"]
}

#-------------------------------------
# VPC Endpoint Security Group
#-------------------------------------
resource "aws_security_group" "cloudtech_vpc_endpoint_ssm_sg" {
  name        = "${var.project}-vpc-endpoint-ssm-sg"
  description = "SystemsManager SessionManager"
  vpc_id      = aws_vpc.cloudtech_vpc.id

  tags = {
    Name    = "${var.project}-vpc-endpoint-ssm-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "ingress_vpc_endpoint_ssm" {
  security_group_id = aws_security_group.cloudtech_vpc_endpoint_ssm_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "443"
  to_port           = "443"
  cidr_blocks       = ["10.0.0.0/21"]
}

resource "aws_security_group_rule" "egress_vpc_endpoint" {
  security_group_id = aws_security_group.cloudtech_vpc_endpoint_ssm_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  cidr_blocks       = ["0.0.0.0/0"]
}

#-------------------------------------
# ALB Security Group
# インバウンド: 80, 443
#-------------------------------------
resource "aws_security_group" "cloudtech_alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "alb"
  vpc_id      = aws_vpc.cloudtech_vpc.id
  tags = {
    Name    = "${var.project}-alb-sg"
    project = var.project
  }
}

resource "aws_security_group_rule" "ingress_http_alb" {
  security_group_id = aws_security_group.cloudtech_alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_https_alb" {
  security_group_id = aws_security_group.cloudtech_alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "443"
  to_port           = "443"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb" {
  security_group_id = aws_security_group.cloudtech_alb_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
  cidr_blocks       = ["0.0.0.0/0"]
}

#------------------------------------
# EC2 from_alb Security Group
#------------------------------------
# EC2がALBのセキュリティグループからのトラフィックのみ許可するセキュリティグループ
resource "aws_security_group" "cloudtech_web_sg" {
  name        = "${var.project}-web-sg"
  description = "from alb"
  vpc_id      = aws_vpc.cloudtech_vpc.id

  tags = {
    Name    = "${var.project}-web-sg"
    Project = var.project
  }
}

# ingress_from_alb_to_ec2
resource "aws_security_group_rule" "ingress_from_alb_to_ec2" {
  security_group_id = aws_security_group.cloudtech_web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
  # ALBのセキュリティグループからインバウンドを許可
  source_security_group_id = aws_security_group.cloudtech_alb_sg.id
}


