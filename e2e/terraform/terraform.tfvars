region               = "us-east-1"
instance_type        = "t2.medium"
server_count         = "3"
client_count         = "4"
windows_client_count = "1"

nomad_server_configs = [
  ["shared/nomad/base.hcl", "shared/nomad/indexed/server-0.hcl"],
  ["shared/nomad/base.hcl", "shared/nomad/indexed/server-1.hcl"],
  ["shared/nomad/base.hcl", "shared/nomad/indexed/server-2.hcl"]
]

nomad_client_configs_linux = [
  ["shared/nomad/base.hcl", "shared/nomad/indexed/client-1.hcl"],
  ["shared/nomad/base.hcl", "shared/nomad/indexed/client-2.hcl"],
  ["shared/nomad/base.hcl", "shared/nomad/indexed/client-3.hcl"]
]

nomad_client_configs_windows = [
  ["shared/nomad/base.hcl", "shared/nomad/client-windows.hcl"]
]
