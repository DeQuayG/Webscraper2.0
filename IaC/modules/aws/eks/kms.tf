resource "aws_kms_key" "eks" {
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  #   enable_key_rotation      = var.rotation_enabled
  deletion_window_in_days = 7
}