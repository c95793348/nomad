variable "name" {
  description = "Used to name various infrastructure components"
  default     = "nomad-e2e"
}

variable "region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "The AWS availability zone to deploy to."
  default     = "us-east-1a"
}

variable "indexed" {
  description = "Different configurations per client/server"
  default     = true
}

variable "instance_type" {
  description = "The AWS instance type to use for both clients and servers."
  default     = "t2.medium"
}

variable "server_count" {
  description = "The number of servers to provision."
  default     = "3"
}

variable "client_count" {
  description = "The number of clients to provision."
  default     = "4"
}

variable "windows_client_count" {
  description = "The number of windows clients to provision."
  default     = "1"
}

variable "nomad_sha" {
  description = "The sha of Nomad to provision"
  default     = ""
}

variable "nomad_version" {
  description = "The release version of Nomad to provision"
  default     = ""
}

variable "nomad_local_binary" {
  description = "The path to a local binary to provision"
  default     = ""
}

variable "aws_assume_role_arn" {
  description = "The AWS IAM role to assume (not used by human users)"
  default     = ""
}

variable "aws_assume_role_session_name" {
  description = "The AWS IAM session name to assume (not used by human users)"
  default     = ""
}

variable "aws_assume_role_external_id" {
  description = "The AWS IAM external ID to assume (not used by human users)"
  default     = ""
}

variable "nomad_server_configs" {
  description = "A list of lists of config files to upload to the cluster"
  type        = list(list(string))
  default     = []
}

variable "nomad_client_configs_linux" {
  description = "A list of lists of config files to upload to the cluster"
  type        = list(list(string))
  default     = []
}

variable "nomad_client_configs_windows" {
  description = "A list of lists of config files to upload to the cluster"
  type        = list(list(string))
  default     = []
}

variable "nomad_default_server_configs" {
  description = "A default list of server config files"
  type        = list(string)
  default     = ["shared/nomad/base.hcl", "shared/nomad/server.hcl"]
}

variable "nomad_default_client_configs_linux" {
  description = "A default list of linux client config files"
  type        = list(string)
  default     = ["shared/nomad/base.hcl", "shared/nomad/client.hcl"]
}

variable "nomad_default_client_configs_windows" {
  description = "A default list of windows client config files"
  type        = list(string)
  default     = ["shared/nomad/base.hcl", "shared/nomad/client-windows.hcl"]
}


variable "consul_server_configs" {
  description = "A list of lists of config files to upload to the cluster"
  type        = list(list(string))
  default     = []
}

variable "consul_client_configs" {
  description = "A list of lists of config files to upload to the cluster"
  type        = list(list(string))
  default     = []
}

variable "consul_default_server_configs" {
  description = "A default list of server config files"
  type = list(string)
  default =   ["shared/consul/base.json", "shared/consul/server.json", "shared/consul/retry_aws.json"]
}

variable "consul_default_client_configs" {
  description = "A default list of client config files"
  type = list(string)
  default =   ["shared/consul/base.json", "shared/consul/retry_aws.json"]
}


variable "vault_server_configs" {
  description = "A list of lists of config files to upload to the cluster"
  type        = list(list(string))
  default     = []
}

variable "vault_default_server_configs" {
  description = "A default list of server config files"
  type = list(string)
  default =   ["shared/vault/vault.hcl"]
}
