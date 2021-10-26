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
    MacAddress = "B8:AE:ED:79:5E:1D"


    IPAddress = "172.31.241.37"

    Gateway = "172.31.241.33"
    Mask = "255.255.255.224"
  }
}

resource "tinkerbell_template" "HelloWorldTemplate" {
  name    = "foo"
  content = <<EOF
version: "0.1"
name: hello_world_workflow
global_timeout: 600
tasks:
  - name: "hello world"
    worker: "{{.device_1}}"
    actions:
      - name: "hello_world"
        image: hello-world
        timeout: 60
EOF
}


resource "tinkerbell_workflow" "Home1" {
  template  = tinkerbell_template.HelloWorldTemplate.id
  hardwares = <<EOF
{"device_1":"172.31.241.37"}
EOF

  depends_on = [
    module.IntelNUC.Hardware,
  ]
}

