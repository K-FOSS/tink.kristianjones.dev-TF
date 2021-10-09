variable "Tinkerbell" {
  type = object({
    Connection = object({
      Hostname = string
      Port = string
    })

    Credentials = object({
      Username = string
      Password = string
    })
  })
}