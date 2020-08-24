module "consul_server" {

  depends_on = [aws_instance.server]
  count      = var.server_count

  source = "./install-consul"

  config_files = count.index < length(var.consul_server_configs) ? var.consul_server_configs[count.index] : var.consul_default_server_configs

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
module "consul_client_linux" {

  depends_on = [aws_instance.client_linux]
  count      = var.client_count

  source = "./install-consul"

  config_files = count.index < length(var.consul_client_configs) ? var.consul_client_configs[count.index] : var.consul_default_client_configs

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
module "consul_client_windows" {

  depends_on = [aws_instance.client_windows]
  count      = var.windows_client_count

  source = "./install-consul"

  config_files = count.index < length(var.consul_client_configs) ? var.consul_client_configs[count.index] : var.consul_default_client_configs

  connection = {
    type        = "ssh"
    user        = "Administrator"
    host        = "${aws_instance.client_windows[count.index].public_ip}"
    port        = 22
    private_key = module.keys.private_key_pem
  }
}
