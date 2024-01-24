resource "aws_iam_role" "elastic_beanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_web_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_multicontainer_docker" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
}

resource "aws_iam_instance_profile" "elastic_beanstalk_ec2_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-role"
  role = aws_iam_role.elastic_beanstalk_ec2_role.name
}

resource "aws_iam_policy" "ecr_access" {
  name        = "ElasticBeanstalkECRAccess"
  description = "Policy for Elastic Beanstalk instances to access ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ses_access" {
  name        = "ElasticBeanstalkSESAccess"
  description = "Policy for Elastic Beanstalk instances to access Amazon SES"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:Get*",
          "ses:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access" {
  name        = "ElasticBeanstalkS3Access"
  description = "Policy for Elastic Beanstalk instances to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "beanstalk_ec2_ecr_policy_attachment" {
  policy_arn = aws_iam_policy.ecr_access.arn
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_ses_policy_attachment" {
  policy_arn = aws_iam_policy.ses_access.arn
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access.arn
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
}


