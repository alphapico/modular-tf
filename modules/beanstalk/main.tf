resource "aws_elastic_beanstalk_application" "charonium" {
  name        = var.app_name
  description = "Elastic Beanstalk application for ${var.app_name}"
}

resource "aws_elastic_beanstalk_environment" "charonium" {
  name                = "${var.env_prefix}-${var.app_name}"
  application         = aws_elastic_beanstalk_application.charonium.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.6 running Docker"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/health"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  # setting {
  #   namespace = "aws:elasticbeanstalk:healthreporting:system"
  #   name      = "ConfigDocument"
  #   value = jsonencode({
  #     "ApplicationRequestsFailureThreshold" = 5
  #     "InstanceHealthCheckInterval"         = 30
  #   })
  # }


  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name      = "HOST"
  #   value     = aws_elastic_beanstalk_environment.charonium.endpoint_url
  # }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = var.app_port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_USER"
    value     = var.db_username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_PASSWORD"
    value     = var.db_password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_DB"
    value     = var.db_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_PORT"
    value     = var.postgres_port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "postgresql://${var.db_username}:${var.db_password}@${var.rds_endpoint}/${var.db_name}?schema=public"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DOCKER_APP"
    value     = "${var.ecr_repo_url}:${var.docker_img_tag}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_REGION"
    value     = var.region
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JWT_SECRET"
    value     = var.jwt_secret
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FRONTEND_DOMAIN"
    value     = var.frontend_domain
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EMAIL_NAME"
    value     = var.email_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EMAIL_FROM"
    value     = var.email_from
  }


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elastic_beanstalk_ec2_instance_profile.name
  }

  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "InstanceType"
  #   value     = "t3.medium"
  # }


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = join(",", var.security_groups)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnet_ids)
  }
}


