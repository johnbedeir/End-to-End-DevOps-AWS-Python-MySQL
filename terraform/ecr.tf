resource "aws_ecr_repository" "ecr_repo" {
  name = "todo-list"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_repo_2" {
  name = "todo-db"
  image_scanning_configuration {
    scan_on_push = true
  }
}
