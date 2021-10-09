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
  }
}

provider "tinkerbell" {
  grpc_authority = "tink-grpc-cont.service.kjdev:42113"
  cert_url       = "http://tink-http-cont.service.kjdev:42114/cert"
}