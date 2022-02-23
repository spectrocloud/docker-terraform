terraform {
  required_providers {
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }

    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }

    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }

    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }

    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }

    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}