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
  iso_url           = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2" 
  iso_checksum      = "sha512:aa1963a7356a7fab202e5eebc0c1954c4cbd4906e3d8e9bf993beb22e0a90cd7fe644bd5e0fb5ec4b9fbea16744c464fda34ef1be5c3532897787d16c7211f86"
  iso_target_path   = "./Downloads"
  output_directory  = "output-build"
  vm_name           = "packer-golden.qcow2"
  disk_image        = true
  efi_boot          = true
  efi_firmware_code = "/usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd"
  efi_firmware_vars = "/usr/share/edk2-ovmf/x64/OVMF_VARS.4m.fd"
  boot_wait         = "20s"
  accelerator       = "kvm"
  machine_type      = "q35"
  format            = "qcow2"
  cpus              = "2"
  disk_interface    = "virtio"
  disk_size         = "20G"
  memory            = "2048"
  communicator      = "ssh"
  ssh_username      = "packer"
  ssh_private_key_file  = "~/.ssh/id_ed25519_pack"
  ssh_port          = 2222
  ssh_timeout       = "20m"
  host_port_min     = 2222
  host_port_max     = 2222
  cd_files = ["./meta-data", "./user-data"]
  cd_label = "cidata"
  qemuargs          = [
    ["-netdev", "user,id=net0,hostfwd=tcp::2222:-:22"],
    ["-device", "virtio-net,netdev=net0"]
  ]
  #boot_command      = [
  #"<wait2><enter><wait10>",
  #"root<enter>",
  #]
}  

build {
    sources =["source.qemu.golden"]

    provisioner "shell" {
      inline  = [
        "sudo apt update",
        "sudo apt install -y python3 python3-pip aptitude",
      ]
    }

    provisioner "ansible" {
      playbook_file = "./ansible/provisioner.yml"
  }
}
