resource "aws_ecr_repository" "charonium" {
  name = var.app_name
}

resource "aws_ecr_lifecycle_policy" "charonium_lifecycle_policy" {
  repository = aws_ecr_repository.charonium.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images images older than 7 days"
        action = {
          type = "expire"
        }
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
      },
      {
        rulePriority = 2
        description  = "Keep only the 10 most recent unused tagged images"
        action = {
          type = "expire"
        }
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["dev-", "v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
      }
    ]
  })
}
