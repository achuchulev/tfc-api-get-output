resource "random_pet" "random_name" {
  length    = var.words_number
  separator = "-"
}
