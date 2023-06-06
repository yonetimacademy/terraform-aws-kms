resource "aws_kms_key" "mq" {
  count                    = (var.mq_encryption == true) ? 1 : 0
  description              = "${var.tenant}-${var.name}-mq-kms-${var.environment}"
  key_usage                = var.key_usage
  customer_master_key_spec = var.cmk_spec
  deletion_window_in_days  = var.deletion_window
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.multi_region

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "auto-mq-1",
  "Statement": [
    {
      "Sid": "Allow access to Amazon MQ for all principals in the account that are authorized to use Amazon MQ",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:CreateGrant",
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey*",
        "kms:Encrypt",
        "kms:ReEncrypt*"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": [
            "mq.${data.aws_region.current.name}.amazonaws.com",
            "elasticfilesystem.${data.aws_region.current.name}.amazonaws.com"
          ],
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
    Name        = "${var.tenant}-${var.name}-mq-kms-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_kms_alias" "mq" {
  count         = (var.mq_encryption == true) ? 1 : 0
  name          = "alias/${var.tenant}/${var.name}/mq/${var.environment}"
  target_key_id = aws_kms_key.mq[0].key_id
}