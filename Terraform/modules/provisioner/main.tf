resource "tls_private_key" "ssh_for_user" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "ssh-key" {
  name         = "sshkey-transfer"
  value        = tls_private_key.ssh_for_user.private_key_pem
  key_vault_id = var.keyvault_id
}

locals {
  fqdn     = trim(var.fqdn, ".")
  ssh_path = trimsuffix(var.ssh_path, ".pub")
}

resource "local_file" "ans_host" {
  filename = "${path.root}/../Ansible/inventory/hosts.txt"
  content  = templatefile("${path.module}/hosts.tftpl", { ip = local.fqdn, user = var.username, ssh_path = local.ssh_path })
}

resource "local_file" "ans_vars" {
  filename = "${path.root}/../Ansible/variables/variables.yml"
  content = templatefile("${path.module}/variables.tftpl",
    { username     = "manager",
      project_name = var.project_name,
      db_admin     = var.db_admin,
      host         = var.host,
      domain       = local.fqdn,
      user_ssh_key = tls_private_key.ssh_for_user.public_key_openssh
  })
}


resource "time_sleep" "wait" {
  depends_on = [local_file.ans_host, local_file.ans_vars]

  create_duration = "30s"
}
resource "null_resource" "run_ansible" {
  depends_on = [time_sleep.wait]
  provisioner "local-exec" {
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    command     = "ansible-playbook -i ${path.root}/../Ansible/inventory/hosts.txt ${path.root}/../Ansible/root_playbook.yml --extra-vars \"password=${var.db_password}\""
  }
}