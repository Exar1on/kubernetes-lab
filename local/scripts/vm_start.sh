#!/bin/bash

#Define default network and services
systemctl start libvirtd

#file="./default-network.xml"
#if [ -e "$file" ];then
#	echo "default network file exists"
#else 
cat > default-network.xml <<EOF
<network>
	<name>default</name>
	<forward mode='nat'/>
	<bridge name='virbr0' stp='on' delay='0'/>
	<ip address='192.168.128.1' netmask='255.255.255.0'>
		<dhcp>
			<range start='192.168.128.2' end='192.168.128.254' />
		</dhcp>
	</ip>
</network>
EOF
#fi
virsh net-undefine default
virsh net-define default-network.xml
virsh net-start default
virsh net-autostart default
virsh net-list --all

virsh undefine --domain kubernetes-control --nvram

#define vm parameters
virt-install \
	--name kubernetes-control \
	--connect qemu:///system \
	--boot uefi \
	--memory 2000 \
	--vcpus 2 \
	--disk path=./output-build/packer-golden.qcow2,format=qcow2,bus=virtio \
	--import \
	--os-variant debian13 \
	--network network=default,model=virtio \
	--graphics none \
	&
