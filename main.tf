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
