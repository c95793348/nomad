module "vault_server" {

  depends_on = [aws_instance.server]
  count      = var.server_count

  source = "./install-vault"

  config_files = count.index < length(var.vault_server_configs) ? var.vault_server_configs[count.index] : var.vault_default_server_configs

  connection = {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.server[count.index].public_ip}"
    port        = 22
    private_key = module.keys.private_key_pem
  }
}
