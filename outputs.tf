output "rds_key_id" {
	value = aws_kms_key.rds[0].arn
}

output "elasticache_key_id" {
	value = aws_kms_key.elasticache[0].arn
}

output "dynamodb_key_id" {
	value = aws_kms_key.dynamodb[0].arn
}