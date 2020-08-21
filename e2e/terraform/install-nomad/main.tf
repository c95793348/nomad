locals {
  # abstract-away platform-specific parameter expectations
  _platform_install_prefix = var.platform == "windows_amd64" ? "C:/opt/install-nomad.ps1 -" : "/opt/install-nomad --"
  install_script_sha       = "${local._platform_install_prefix}nomad_sha"
  install_script_version   = "${local._platform_install_prefix}nomad_version"
  install_script_binary    = "${local._platform_install_prefix}nomad_binary"

  install_config_script = var.platform == "windows_amd64" ? "C:/opt/install-config.ps1" : "/opt/install-config"
}

resource "null_resource" "install_nomad_sha" {

  count      = var.nomad_sha != "" ? 1 : 0
  depends_on = [null_resource.upload_configs]
  triggers = {
    nomad_sha = var.nomad_sha
  }

  connection {
    type        = "ssh"
    user        = var.connection.user
    host        = var.connection.host
    port        = var.connection.port
    private_key = var.connection.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "${local.install_script_sha} ${var.nomad_sha}"
    ]
  }
}

resource "null_resource" "install_nomad_version" {

  count      = var.nomad_version != "" ? 1 : 0
  depends_on = [null_resource.upload_configs]
  triggers = {
    nomad_version = var.nomad_version
  }

  connection {
    type        = "ssh"
    user        = var.connection.user
    host        = var.connection.host
    port        = var.connection.port
    private_key = var.connection.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "${local.install_script_version} ${var.nomad_version}"
    ]
  }
}

resource "null_resource" "install_nomad_binary" {

  count      = var.nomad_local_binary != "" ? 1 : 0
  depends_on = [
    null_resource.upload_configs,
    null_resource.upload_nomad_binary
  ]
  triggers = {
    nomad_binary_sha = filemd5(var.nomad_local_binary)
  }

  connection {
    type        = "ssh"
    user        = var.connection.user
    host        = var.connection.host
    port        = var.connection.port
    private_key = var.connection.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "${local.install_script_binary} /tmp/nomad"
    ]
  }
}

resource "null_resource" "upload_nomad_binary" {

  count      = var.nomad_local_binary != "" ? 1 : 0
  depends_on = [null_resource.upload_configs]
  triggers = {
    nomad_binary_sha = filemd5(var.nomad_local_binary)
  }

  connection {
    type        = "ssh"
    user        = var.connection.user
    host        = var.connection.host
    port        = var.connection.port
    private_key = var.connection.private_key
  }

  provisioner "file" {
    source      = var.nomad_local_binary
    destination = "/tmp/nomad"
  }
}


resource "null_resource" "upload_configs" {

  for_each = var.config_files
  triggers = {
    contents = filemd5(each.key)
  }

  connection {
    type        = "ssh"
    user        = var.connection.user
    host        = var.connection.host
    port        = var.connection.port
    private_key = var.connection.private_key
  }

  provisioner "file" {
    source      = each.key
    destination = "/tmp/${basename(each.key)}"
  }
}

resource "null_resource" "install_configs" {

  depends_on = [null_resource.upload_configs]

  connection {
    type        = "ssh"
    user        = var.connection.user
    host        = var.connection.host
    port        = var.connection.port
    private_key = var.connection.private_key
  }

  provisioner "remote-exec" {
    inline = [
      #"sudo mv /tmp/install-config ${local.install_config_script}",
      #"${local.install_config_script}",
      # TODO: this is temporary until we bake it into the AMI
      "sudo mkdir -p /etc/nomad.d",
      "sudo cp /tmp/*.hcl /etc/nomad.d/",
      "sudo chown -R root:root /etc/nomad.d",
      "sudo cp /tmp/nomad.service /etc/systemd/system/nomad.service",
    ]
  }

}
