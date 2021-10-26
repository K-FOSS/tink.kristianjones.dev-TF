output "TinkAdmin" {
  value = {
    Username = data.vault_generic_secret.TinkAdmin.data["Username"]
    Password =  data.vault_generic_secret.TinkAdmin.data["Password"]
  }
}

#
# NetBox
#
output "Netbox" {
  value = {
    Token = data.vault_generic_secret.Netbox.data["TOKEN"]
  }
}
