# eSchool-Task-2
DevOps Internship 2022 (SoftServe) <br />
# Task: <br /> 
Write Terraform script to deploy infrastructure for [eSchool Application](https://github.com/Mitek/eSchool) <br /> 
## Requirments: 
- Terraform
- Ansible 
- Azure CLI 
## Script will deploy:
- VM (host application)
- DNS zone (to link public IP of VM and your application domain name)
- MySQL Flexible server (using Private DNS zone)
- KeyVault (for passwords)
#### And provision:
- New database and user (to omit using admin user/password of MySQL server in app)
- Setup directories, users and privilegies for application
- Obtain SSL certificate for application (using Certbot)
- Generate SSH key for connecting to server as user (OR as I used it: to upload a new version of app via Jenkins)
- Creating systemd file to run application as a service

### Usage:
- Clone repo
- Run `Scripts/init.sh` to configure [backend](https://www.terraform.io/language/settings/backends) OR create it [manualy](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
- Edit config files:
  - `Terraform/variables.auto.tfvars`- deployment configs 
  - `Ansible/variables/ssl.yml` - SSL certificate configs for Certbot 
  - `Ansible/variables/mysql_conf.yml` - change 'INPUT_PASSWORD' to password which be used for application database (which is not the same as admin password) <br />
 *Note*: These files - `Ansible/variables/variables.yml` and `Ansible/inventory/hosts.txt` will be generated by Terraform. <br />
 If you need to change something edit their parent template files `variables.tftpl` and `hosts.tftpl` which are placed in `Terraform/modules/provisioner/`
 - Run `terraform init`
 - `terraform apply`
## Features:  <br />
#### Terraform:
  - Remote state - tfstate file is stored in Azure Storage 
  - Modular structure 
  - Passwords is generated by script and will be pushed to KeyVault 
  - Ansible `host` and `variables` files are generated by Terraform template file function  <br />
