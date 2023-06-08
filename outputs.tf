output "rds_key_id" {
	value = aws_kms_key.rds[*].arn
}

output "elasticache_key_id" {
	value = aws_kms_key.elasticache[*].arn
}

output "dynamodb_key_id" {
	value = aws_kms_key.dynamodb[*].arn
}

output "s3_key_id" {
	value = aws_kms_key.s3[*].arn
}

output "mq_key_id" {
	value = aws_kms_key.mq[*].arn
}

output "efs_key_id" {
	value = aws_kms_key.efs[*].arn
}