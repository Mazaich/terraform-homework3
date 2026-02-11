[all:vars]
ansible_user=${ssh_user}
ansible_ssh_private_key_file=${ssh_key_path}
ansible_python_interpreter=/usr/bin/python3

[webservers]
%{ for vm in jsondecode(webservers) ~}
${vm.name} ansible_host=${vm.external_ip} fqdn=${vm.fqdn} type=${vm.type}
%{ endfor ~}

[databases]
%{ for vm in jsondecode(databases) ~}
${vm.name} ansible_host=${vm.external_ip} fqdn=${vm.fqdn} type=${vm.type}
%{ endfor ~}

[storage]
%{ for vm in jsondecode(storage) ~}
${vm.name} ansible_host=${vm.external_ip} fqdn=${vm.fqdn} type=${vm.type}
%{ endfor ~}

[all_machines:children]
webservers
databases
storage
