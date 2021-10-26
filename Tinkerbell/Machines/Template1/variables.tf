variable "Networking" {
  type = object({
    MacAddress = string

    IPAddress = string

    Gateway = string

    Mask = string
  })
  
}