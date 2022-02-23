terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.12"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "ubuntu" {
  name = "ubuntupf"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-ubuntupf"
}

resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = "/home/ubuntu/spectro/pfsense/terraform/pfsense-install.qcow2"
  format = "qcow2"
}

data "template_file" "config" {
  template = file("${path.module}/config_tmpl.xml")
  vars = {
    NETWORK_1 = "vtnet0"
    NETWORK_2 = "vtnet1"
    IP_ADDR_1 = "dhcp"
    IP_ADDR_2 = "192.168.124.26"
    SUBNET_1 = ""
    SUBNET_2 = "24"
  }
}

output "config_value" {
  value = data.template_file.config.rendered
}

output "user_data_value" {
  value = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.tmpl")
  vars = {
    CONFIG_XML = base64encode(data.template_file.config.rendered)
  }
}

data "template_file" "meta_data" {
  template = file("${path.module}/meta-data")
}

data "template_file" "network_config" {
  template = file("${path.module}/network-config")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  meta_data      = data.template_file.meta_data.rendered
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.ubuntu.name
}

# Create the machine
resource "libvirt_domain" "domain-ubuntu" {
  name   = "pfsense-terraform"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    #network_name = "default"
    bridge = "br0"
  }

  network_interface {
    #network_name = "default"
    bridge = "virbr2"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

#  console {
#    type        = "pty"
#    target_type = "virtio"
#    target_port = "1"
#  }

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = "0.0.0.0"
    autoport    = true
  }
}

