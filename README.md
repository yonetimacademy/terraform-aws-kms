# terraform-aws-kms

Magicorn made Terraform Module for AWS Provider
--
```
module "kms" {
  source      = "magicorntech/kms/aws"
  version     = "0.0.3"
  tenant      = var.tenant
  name        = var.name
  environment = var.environment

  ##### KMS Configuration #####
  # Enabled Services
  rds_encryption         = true
  elasticache_encryption = true
  dynamodb_encryption    = true
  s3_encryption          = true
  mq_encryption          = false
  efs_encryption         = false

  # Generic Key Configuration
  key_usage           = "ENCRYPT_DECRYPT"
  cmk_spec            = "SYMMETRIC_DEFAULT"
  deletion_window     = 7
  is_enabled          = true
  enable_key_rotation = true
  multi_region        = false
}
```