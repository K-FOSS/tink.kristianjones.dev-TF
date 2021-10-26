terraform {
  required_providers {
    #
    # Hashicorp Vault
    #
    # Docs: https://registry.terraform.io/providers/hashicorp/vault/latest/docs
    #
    vault = {
      source = "hashicorp/vault"
      version = "2.24.0"
    }
  }
}

data "vault_generic_secret" "TinkAdmin" {
  path = "CORE0_SITE1/Tinkerbell"
}

#
# Netbox
#
data "vault_generic_secret" "Netbox" {
  path = "CORE0_SITE1/Netbox"
}