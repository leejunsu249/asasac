resource "random_password" "secret_value" {
  length  = 16
  special = var.special
}

resource "aws_secretsmanager_secret" "secret_value_credentials" {
  name = var.name
}

resource "aws_secretsmanager_secret_version" "secret_value_credentials" {
  secret_id     = aws_secretsmanager_secret.secret_value_credentials.id
  secret_string = random_password.secret_value.result
}

resource "aws_secretsmanager_secret" "secret_value_credentials_proxy" {
  count = var.username != "" ? 1:0

  name = var.smname
}

resource "aws_secretsmanager_secret_version" "secret_value_credentials_proxy" {
  count = var.username != "" ? 1:0

  secret_id     = aws_secretsmanager_secret.secret_value_credentials_proxy[count.index].id
  secret_string = <<SECRET_STRING
  {
    "username": "${var.username}",
    "password": "${random_password.secret_value.result}"
  } 
  SECRET_STRING
}