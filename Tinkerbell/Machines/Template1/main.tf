terraform {
  required_providers {
    #
    # Tinkerbell
    #
    # Docs: https://registry.terraform.io/providers/tinkerbell/tinkerbell/latest/docs
    #
    tinkerbell = {
      source  = "tinkerbell/tinkerbell"
      version = "0.1.1"
    }

    #
    # Random
    #
    # Docs: https://registry.terraform.io/providers/hashicorp/random/latest/docs
    #
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }

    #
    # Netbox
    #
    # Docs: https://registry.terraform.io/providers/e-breuninger/netbox/latest
    #
    netbox = {
      source = "e-breuninger/netbox"
      version = "0.3.0"
    }
  }
}

resource "random_uuid" "HardwareID" { }

resource "tinkerbell_hardware" "Hardware" {
  data = <<EOF
{
  "id": "${random_uuid.HardwareID.result}",
  "metadata": {
    "facility": {
      "facility_code": "onprem"
    },
    "instance": {},
    "state": ""
  },
  "network": {
    "interfaces": [
      {
        "dhcp": {
          "arch": "x86_64",
          "ip": {
            "address": "${var.Networking.IPAddress}",
            "gateway": "${var.Networking.Gateway}",
            "netmask": "${var.Networking.Mask}"
          },
          "mac": "${var.Networking.MacAddress}",
          "name_servers": [
            "172.16.100.25"
          ],
          "uefi": true
        },
        "netboot": {
          "allow_pxe": true,
          "allow_workflow": true
        }
      }
    ]
  }
}
EOF
}