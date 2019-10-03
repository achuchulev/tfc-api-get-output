resource "random_pet" "random_name" {
  length    = var.length
  separator = "-"
}
