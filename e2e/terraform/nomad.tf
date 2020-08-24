locals {
  nomad_config_root = "${path.root}/config/nomad/${var.profile}"
}

module "nomad_server" {

  depends_on = [aws_instance.server, module.consul_server]
  count      = var.server_count

  source = "./install-nomad"

  nomad_version      = var.nomad_version
  nomad_sha          = var.nomad_sha
  nomad_local_binary = var.nomad_local_binary

  config_files = compact(setunion(
    fileset(path.module, "config/nomad/${var.profile}/*.hcl"),
    fileset(path.module, "config/nomad/${var.profile}/server/*.hcl"),
    fileset(path.module, "config/nomad/${var.profile}/server/indexed/*${count.index}.hcl"),
  ))

  connection = {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.server[count.index].public_ip}"
    port        = 22
    private_key = module.keys.private_key_pem
  }
}

# TODO: split out the different Linux targets (ubuntu, centos, arm, etc.) when
# they're available
module "nomad_client_linux" {

  depends_on = [aws_instance.client_linux, module.consul_client_linux]
  count      = var.client_count

  source = "./install-nomad"

  nomad_version      = var.nomad_version
  nomad_sha          = var.nomad_sha
  nomad_local_binary = var.nomad_local_binary

  config_files = compact(setunion(
    fileset(path.module, "config/nomad/${var.profile}/*.hcl"),
    fileset(path.module, "config/nomad/${var.profile}/client-linux/*.hcl"),
    fileset(path.module, "config/nomad/${var.profile}/client-linux/indexed/*${count.index}.hcl"),
  ))

  connection = {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.client_linux[count.index].public_ip}"
    port        = 22
    private_key = module.keys.private_key_pem
  }
}

# TODO: split out the different Windows targets (2016, 2019) when they're
# available
module "nomad_client_windows" {

  depends_on = [aws_instance.client_windows, module.consul_client_windows]
  count      = var.windows_client_count

  source = "./install-nomad"

  nomad_version      = var.nomad_version
  nomad_sha          = var.nomad_sha
  nomad_local_binary = var.nomad_local_binary

  config_files = compact(setunion(
    fileset(path.module, "config/nomad/${var.profile}/*.hcl"),
    fileset(path.module, "config/nomad/${var.profile}/client-windows/*.hcl"),
    fileset(path.module, "config/nomad/${var.profile}/client-windows/indexed/*${count.index}.hcl"),
  ))

  connection = {
    type        = "ssh"
    user        = "Administrator"
    host        = "${aws_instance.client_windows[count.index].public_ip}"
    port        = 22
    private_key = module.keys.private_key_pem
  }
}
