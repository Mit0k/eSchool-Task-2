resource "local_file" "ans_hosts" {
  filename = "hosts.txt"
  content = templatefile("${path.module}/hosts.tftpl", { ip = var.fqdn, user = var.username, ssh_path =  var.ssh_path }  )
  provisioner "local-exec" {
    command = "ansible all -m ping"
  }
}
