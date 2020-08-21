variable "platform" {
  type        = string
  description = "Platform ID (ex. \"linux_amd64\" or \"windows_amd64\")"
  default     = "linux_amd64"
}

variable "nomad_version" {
  type        = string
  description = "Nomad release version (ex. \"0.10.3\")"
  default     = ""
}

variable "nomad_sha" {
  type        = string
  description = "Nomad build full SHA (ex. \"fef22bdbfa094b5d076710354275e360867261aa\")"
  default     = ""
}

variable "nomad_local_binary" {
  type        = string
  description = "Path to local Nomad build (ex. \"/home/me/bin/nomad\")"
  default     = ""
}

variable "config_files" {
  type        = set(string)
  description = "List of configuration files to upload"
  default     = []
}

variable "connection" {
  type = object({
    type        = string
    user        = string
    host        = string
    port        = number
    private_key = string
  })
  description = "ssh connection information for remote target"
}
