#------------------------------------
# IAM Role
#------------------------------------
# SSM Managed Instance Core
data "aws_iam_policy" "ssm_managed_instancecore" {
  # 許可ポリシー
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm_role" {
  # 信頼ポリシー
  name = "${var.project}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
# IAMロールにAmazonSSMManagedInstanceCoreポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "allow_ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.ssm_managed_instancecore.arn
}




