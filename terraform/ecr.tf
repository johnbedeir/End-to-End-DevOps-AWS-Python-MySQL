resource "aws_ecr_repository" "ecr_repo" {
  name = "todo-app-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_repo_2" {
  name = "todo-db-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}
