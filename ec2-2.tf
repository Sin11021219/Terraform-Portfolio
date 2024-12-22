#===============================================================
#EC2
#================================================================
#最新のAMI IDを取得
data "aws_ssm_parameter" "amzn2_ami" {
    name = "/aws/server/ami-amazon-linux-latest/ammzn2-ami-hvm-x86_64-gp2"
}

#1台目のEC2
resource "aws_instance" "webserver_ec2_1" {
    ami                         = data.aws_ssm_parameter.aman2_ami.value
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.subnet_private1.id
    assosiate_public_ip_address = false

    iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
    vpc_security_group_ids = [
        aws_security_group.ec2_ssm_sg.id,
        aws_security_group.web_sg.id
   ]
    # Apache インストール
    user_data = base64encode(file("./script.sh"))

    tags = {
       Name    = "${var.project}-webserver-1"
       Project = var.project 

    }
}

#2台目のEC2
resource "aws_instance" "webserver_ec2_2" {
    ami                         = data.aws_ssm_parameter.aman2_ami.value
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.subnet_private1.id
    assosiate_public_ip_address = false

    iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
    vpc_security_group_ids = [
        aws_security_group.ec2_ssm_sg.id,
        aws_security_group.web_sg.id
   ]
    # Apache インストール
    user_data = base64encode(file("./script.sh"))

    tags = {
       Name    = "${var.project}-webserver-2"
       Project = var.project 

    }
}

# Instance Profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
    role = aws_iam_role.ssm_role.name
    name = aws_iam_role.ssm_role.name
}



