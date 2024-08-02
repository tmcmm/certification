output "master_public_ip" {
  value = module.master_vm.public_ip
}

output "worker_public_ips" {
  value = [module.worker_vm_1.public_ip, module.worker_vm_2.public_ip]
}
