# Creates/manages KMS CMK
resource "aws_kms_key" "kms_app" {
  description              = "Key for Autoscaling"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  policy                   = data.aws_iam_policy_document.iam_policy_document_as_key.json
  deletion_window_in_days  = 30
}