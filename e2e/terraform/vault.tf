module "vault_server" {

  depends_on = [aws_instance.server]
  count      = var.server_count

  source = "./install-vault"

  config_files = compact(setunion(
    fileset(path.module, "config/vault/${var.profile}/*.hcl"),
    fileset(path.module, "config/vault/${var.profile}/server/*.hcl"),
    fileset(path.module, "config/vault/${var.profile}/server/indexed/*${count.index}.hcl"),
  ))

  connection = {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.server[count.index].public_ip}"
    port        = 22
    private_key = module.keys.private_key_pem
  }
}
