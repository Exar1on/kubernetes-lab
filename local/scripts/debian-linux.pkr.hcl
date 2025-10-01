packer {
  required_plugins {
    qemu = {
      version = "v1.1.2"
      source  = "github.com/hashicorp/qemu"
    }
    ansible = {
     version  = "~> 1"
     source   = "github.com/hashicorp/ansible"
    }
  }
}

source "qemu" "golden" {
  iso_url           = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-nocloud-amd64.qcow2"       
  iso_checksum      = "sha512:f88bdcec45b37f5a504b3c1d1f153086ec93f57ac7c691d05a8e912d25f9ba1afaa8152771b0912ff62177fc4169c51710185ec598afc28f9e5b781fcc2b96bb"
  iso_target_path   = "~/Downloads"
  output_directory  = "~/Downloads"
  efi_boot          = true
  efi_firmware_code = "/usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd"
  efi_firmware_vars = "/usr/share/edk2-ovmf/x64/OVMF_VARS.4m.fd"
  accelerator       = "kvm"
  cpus              = "2"
  disk_interface    = "virtio"
  disk_size         = "20G"
  memory            = "2048"
  communicator      = "ssh"
  ssh_username      = "root"
  ssh_agent_auth    = true
}  

build {
    sources =["source.qemu.golden"]
    
    provisioner "ansible" {
      playbook_file = "./ansible/provisioner.yml"
  }
}
