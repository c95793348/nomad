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
    destination = "/tmp/consul-${basename(each.key)}"
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

  # TODO: we'll probably want an on-host provisioning script here
  # instead so that we can bootstrap ACLs and mTLS
  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/consul-*.json /etc/consul.d/",
      "sudo systemctl restart consul",
    ]
  }
}
