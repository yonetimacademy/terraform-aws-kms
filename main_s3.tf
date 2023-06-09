resource "aws_kms_key" "s3" {
  count                    = (var.s3_encryption == true) ? 1 : 0
  description              = "${var.tenant}-${var.name}-s3-kms-${var.environment}"
  key_usage                = var.key_usage
  customer_master_key_spec = var.cmk_spec
  deletion_window_in_days  = var.deletion_window
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.multi_region

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "auto-s3-1",
  "Statement": [
    {
      "Sid": "Allow access through S3 for all principals in the account that are authorized to use S3",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": "s3.${data.aws_region.current.name}.amazonaws.com",
          "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
    },
    {
      "Sid": "Allow direct access to key metadata to the account",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
          "${data.aws_caller_identity.current.arn}"
        ]
      },
      "Action": [
        "kms:*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

  tags = {
    Name        = "${var.tenant}-${var.name}-s3-kms-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "yonetimacademy"
    Terraform   = "yes"
  }
}

resource "aws_kms_alias" "s3" {
  count         = (var.s3_encryption == true) ? 1 : 0
  name          = "alias/${var.tenant}/${var.name}/s3/${var.environment}"
  target_key_id = aws_kms_key.s3[0].key_id
}