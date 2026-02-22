# --------------------
# Terraform Variables
# --------------------
variable "key_name" {
  description = "The name of the existing AWS EC2 Key Pair to use for SSH access"
  type        = string
}
