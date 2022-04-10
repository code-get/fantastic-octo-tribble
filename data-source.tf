
data "local_file" "key_pair_file" {
  filename = "keys/${var.key_pair_filename}"
}
