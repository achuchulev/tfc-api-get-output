output "random_name" {
  value = random_pet.random_name.id
}

output "echo" {
  value = null_resource.echo.*.id
}
