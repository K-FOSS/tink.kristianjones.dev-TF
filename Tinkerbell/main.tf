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

provider "tinkerbell" {
  grpc_authority = "tink-grpc-cont.service.kjdev:42113"
  cert_url       = "http://tink-http-cont.service.kjdev:42114/cert"
}

#
# Netbox
#
provider "netbox" {
  server_url = "http://netbox-http-cont.service.dc1.kjdev:8080"
  api_token = var.Netbox.Token
  allow_insecure_https = false
}

#
# Intel NUC
#
module "IntelNUC" {
  source = "./Machines/Template1"

  Networking = {
    MacAddress = "b8:ae:ed:79:5e:1d"


    IPAddress = "172.31.241.37"

    Gateway = "172.31.241.33"
    Mask = "255.255.255.224"
  }
}

module "VM1" {
  source = "./Machines/Template1"

  Networking = {
    MacAddress = "00:50:56:BE:C4:1C"


    IPAddress = "172.16.0.71"

    Gateway = "172.16.0.1"
    Mask = "255.255.255.128"
  }
}

resource "tinkerbell_template" "HelloWorldTemplate" {
  name    = "homenuc"
  content = <<EOF
version: "0.1"
name: debian_Focal
global_timeout: 1800
tasks:
  - name: "os-installation"
    worker: "{{.intel_nuc}}"
    volumes:
      - /dev:/dev
      - /dev/console:/dev/console
      - /lib/firmware:/lib/firmware:ro
    actions:
      - name: "stream-ubuntu-image"
        image: hello-world:latest
        timeout: 600
EOF
}


resource "tinkerbell_workflow" "HomeCore1" {
  template  = tinkerbell_template.HelloWorldTemplate.id
  hardwares = <<EOF
{"intel_nuc":"b8:ae:ed:79:5e:1d"}
EOF

  depends_on = [
    module.IntelNUC.Hardware,
  ]
}

