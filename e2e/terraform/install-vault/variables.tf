variable "platform" {
  type        = string
  description = "Platform ID (ex. \"linux_amd64\" or \"windows_amd64\")"
  default     = "linux_amd64"
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
