locals {
  fqdn     = trim(var.fqdn, "*.")
  ssh_path = trimsuffix(var.ssh_path, ".pub")
}

resource "local_file" "ans_host" {
  filename = "${path.root}/../Ansible/inventory/hosts.txt"
  content  = templatefile("${path.module}/hosts.tftpl", { ip = local.fqdn, user = var.username, ssh_path = local.ssh_path })
}

resource "local_file" "ans_vars" {
  filename = "${path.root}/../Ansible/variables/variables.yml"
  content = templatefile("${path.module}/variables.tftpl",
  { username     = var.username,
    project_name = var.project_name,
    db_admin     = var.db_admin,
    host         = var.host,
    db_name      = var.project_db_creds.dbname,
    db_user      = var.project_db_creds.username,
    db_pass      = var.project_db_creds.password,

  })
}


resource "time_sleep" "wait" {
  depends_on = [local_file.ans_host]

  create_duration = "30s"
}
resource "null_resource" "run_ansible" {
  depends_on = [time_sleep.wait]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.root}/../Ansible/inventory/hosts.txt ${path.root}/../Ansible/root_playbook.yml"
  }
}

resource "null_resource" "run_mysql_conf" {
  depends_on = [null_resource.run_ansible]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.root}/../Ansible/inventory/hosts.txt ${path.root}/../Ansible/playbooks/mysql.yml --extra-vars \"password=${var.db_password}\""
  }
}