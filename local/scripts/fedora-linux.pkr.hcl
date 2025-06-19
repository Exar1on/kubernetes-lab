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
  iso_url           = "https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-UEFI-UKI-42-1.1.x86_64.qcow2"
  iso_checksum      = "sha256:acaab7d42e413264b92a7b0edb0b07aaf903bb8ed33ec880f73bca92e751269e"
  iso_target_path   = "~/Downloads"
  accelerator       = "kvm"
  cpus              = "2"
  disk_interface    = "virtio"
  disk_size         = "20G"
  memory            = "2048"
  output_directory  = "~/"
  communicator      = "ssh"
  ssh_username      = "terraform"
  ssh_agent_auth    = true
}  

build {
    sources =["source.qemu.golden"]
    
    provisioner "ansible" {
      playbook_file = "./ansible/provisioner.yml"
  }
}
