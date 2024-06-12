output "secret_string" {
  value = random_password.secret_value.result
}

output "secret_arn" {
  value = aws_secretsmanager_secret.secret_value_credentials.arn
}

output "secret_proxy_arn" {
  value = var.username != "" ? "${aws_secretsmanager_secret.secret_value_credentials_proxy[0].arn}" : null
}