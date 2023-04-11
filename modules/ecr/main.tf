resource "aws_ecr_repository" "charonium" {
  name = var.app_name
}

resource "aws_ecr_lifecycle_policy" "charonium_lifecycle_policy" {
  repository = aws_ecr_repository.charonium.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images images older than 14 days"
        action = {
          type = "expire"
        }
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
      }
    ]
  })
}
