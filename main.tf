resource "random_pet" "random_name" {
  length    = var.words_number
  separator = "-"
}

resource "null_resource" "printng-each-word" {
  count = var.words_number
  provisioner "local-exec" {
    command = "echo 'World #${count.index + 1} is ${element(split("-", random_pet.random_name.id), count.index)}!'"
  }
}
