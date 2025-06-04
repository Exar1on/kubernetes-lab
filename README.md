# kubernetes-lab

In this repository I'm planning to implement a certain variations of kubernetes clusters.

The purpose of this project is to learn kubernetes(and other required instruments) by practice.

For now I will implement only local k3s because currently i don't have enough hardware resources to run a vanilla k8s.
When i get familliar with kubernetes enough, I will implement a publicly available service on the Amazon EKS.


The implemetation begins with a "golden images" written using a hashcorp packer, in order to create a stable, replicable VM images withsome basic software provisioning using cloud-init scripts and maybe Ansible scripts if required.

Creation of a infrastructure itself will be implemented via Terraform and k3s scripts.

