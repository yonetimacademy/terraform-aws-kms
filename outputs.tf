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

output "ec2_key_id" {
	value = aws_kms_key.ec2[*].arn
}

output "ec2_key_pair_name" {
	value = aws_key_pair.ec2[*].key_name
}