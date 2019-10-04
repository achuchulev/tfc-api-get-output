resource "random_pet" "random_name" {
  length    = var.words_number
  separator = "-"
}

resource "null_resource" "echo" {
  count = var.words_number

  provisioner "local-exec" {
    command = "echo hello ${count.index + 1}!"
  }
}

resource "tfe_variable" "test" {
  key          = "words_number"
  value        = "4"
  category     = "terraform"
  workspace_id = "atanasc-2/tfc-api-get-output"
}
