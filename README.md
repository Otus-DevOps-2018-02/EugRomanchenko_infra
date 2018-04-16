[![Build Status](https://travis-ci.org/Otus-DevOps-2018-02/EugRomanchenko_infra.svg?branch=ansible-3)](https://travis-ci.org/Otus-DevOps-2018-02/EugRomanchenko_infra)
# EugRomanchenko_infra
EugRomanchenko Infra repository
## Homework-4 (cloud-bastion)
### Connecting to someinternalhost from local machine using one command
`ssh -o ProxyCommand="ssh -W %h:%p $bastion_external_ip" $someinternalhost_ip`
or if PortForwarding enabled in ssh config on server 
`ssh -J $bastion_external_ip:22 $someinternalhost_ip`
### For connecting to someinternalhost using command `ssh someinternalhost`
* Create file **~.ssh/config** 
* Add following lines into this file
```
Host bastion
Hostname $bastion_external_ip
User $username

Host someinternalhost
Hostname $someinternalhost_ip
User $username
ProxyCommand ssh -W %h:%p bastion
```
* Connect to someinternalhost using command
`ssh someinternalhost`
### Connecting to someinternalhost over VPN
bastion_IP=130.211.74.104
someinternalhost_IP=10.132.0.3
## Homework-5 (cloud-testapp)
### Command for running instance and deploy small application
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup_script.sh 
```
or if you would like to upload and run startup script from url (in case when startup script lengh exceeds limit into 256KB)
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://storage.googleapis.com/cloud-testapp/startup_script.sh
```
### Create firewall rule to access our application from Internet (http)
```
gcloud compute --project=infra-197918 firewall-rules create default-puma-server\
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=puma-server 
```
### Informations for access to our application from Internet
testapp_IP=35.204.40.219
testapp_port=9292
## Homework-7 (terraform-1)
### For create simple infrastructure into GCP
* Install Terraform from https://www.terraform.io/downloads.html
* Clone this Git repo
```
git clone -b terraform-1 git@github.com:Otus-DevOps-2018-02/EugRomanchenko_infra.git
```
* Move into folder terraform
* Create file terraform.tfvars based on our GCP value from terraform.tfvars.example"
* Execute two command
```
terraform plan
terraform apply
```
* After this you will see output variable app_external_ip 
* Open our web browser and enter $app_external_ip:9292 into address prompt 
### Homework-7 with *
We add multiply ssh-keys into GCP project metadata through Terraform
When you modify GCP project metadata with Terraform, your existing ssh-keys will remove because Terraform don't known about them.
### Homework-7 with **
* Install Terraform from https://www.terraform.io/downloads.html
* Clone this Git repo
```
git clone -b terraform-1 git@github.com:Otus-DevOps-2018-02/EugRomanchenko_infra.git
```
* Move into folder terraform
* Create file terraform.tfvars based on our GCP value from terraform.tfvars.example"
* Execute two command
```
terraform plan
terraform apply
```
* After this you will see third output variables. One of thih is lb_external_ip
* Open our web browser and enter $lb_external_ip:9292 into address prompt
* Connect to one of two application instance (output variable app_external_ip) 
* Execute command
```
sudo systemctl stop puma.service
```
* Try again open our web browser and enter $lb_external_ip:9292 into address prompt
### Homework-8 (terraform-2)
* Clone this Git repo
```
git clone -b terraform-2 git@github.com:Otus-DevOps-2018-02/EugRomanchenko_infra.git
```
* Move into folder packer
* 
```
packer build -var-file=variables.json app.json
packer build -var-file=variables.json db.json
```
* 
```
cd ../terraform
```
* Create file terraform.tfvars based on our GCP value and planning GCS bucket name from terraform.tfvars.example"
* Initialize remote Terraform module storage-bucket
```
terraform init
```
* Create Google Cloud Sotrage for store terraform.tfstate file
```
terraform plan && terraform apply
```
* Move into one of two folder prod or stage
* Change the value of the variable bucket to the value you entered in the previous step in backend.tf file
* Define our external ip address. For example:
```
curl ifconfig.co
```
* Create file terraform.tfvars based on our GCP value and received at the previous stage by an external ip address
* Initialize local module app, vpc and db
```
terraform init && terraform get
```
* Create test infrasructure
```
terraform plan && terraform apply
```
## Homework-9 (ansible-1)
### Base homework
* Create simple Ansible structure and playbook for clone remote Git repo
* Running simple playbook
```
ansible app clone.yml
```
* Make shure that nothing was change
* Running command
```
ansible app -m command -a "rm -rf ~/reddit"
```
* After that
```
ansible app clone.yml
```
* You can see that the change were made
* We tested this property ansible as the immmutable
### homework with *
For use inventory.json
```
ansible -i inventory.py all -m ping
```
## Homework-10 (ansible-2)
### Base homework
- We will working into multiple Ansible techniques:
  - One playbook - one play
  - One playbook - multiply play
  - Multiple playbook

- Write Ansible Playbook for using on Packer provisioning
- Recreate Golden Image using updated Packer Template
- Recreate Stage environment using Terraform
- Run Ansible Playbook site.yml for deploing our application
### homework with *
- Creaate additional Service Account into GCP with role view GCE
- Configure Dynamic inventory in Ansible based on gce.py
## Homework-11 (ansible-3)
### Выполнено ДЗ № 11

 - [x] Основное ДЗ
 - [x] Задание со *
 - [x] Задание с **

#### В процессе сделано:
 - Произведена реструктуризация инфраструктурного Ansible репозитория
 - Добавлено описание двух окружений stage и prod в Ansible
 - Была использована комьюнити Ansible role nginx
 - С помощью Ansible Vault были зашифрованы sensitive конфиги с паролями пользователей 
 - Для двух окружений было настроено использование Dynamic Inventory
 - С помощью [trytravis](https://github.com/SethMichaelLarson/trytravis) были настроены дополнительные проверки Ansible, Packer и Terraform конфигураций путем запуска тестовых билдов в Travis CI

#### Как запустить проект:
 - Cклонировать git репозиторий
```
git clone -b ansible-3 git@github.com:Otus-DevOps-2018-02/EugRomanchenko_infra.git
```
 - Настроить тестовую инфраструктуру
```
cd terraform/stage
terraform apply
```
 - Учитывая значения output переменных настроить inventory файлы ansible/environments/stage/inventory
 - Выполнить запуск Ansible Playbook
```
cd ansible
ansible-playbook -i environments/stage/inventory playbooks/site.yml
```
 - Для задания со * необходимо внести корректные данные в файл ansible/environments/stage/gce.ini.example
 - Пересоздать тестовую инфраструктуру
``` 
cd ../terraform/stage
terraform destroy
terraform apply
```
 - Выполнить запуск Ansible Playbook
``` 
cd ansible/
ansible-playbook -i environments/stage/gce.py playbooks/site.yml
```

#### Как проверить работоспособность:
 - Перейти по ссылке http://$external_ip

#### PR checklist
 - [x] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания
## Выполнено ДЗ № 12
### В процессе сделано:
 - Настроено использование Vagrant для локальной разработки Ansible ролей
 - Настроено тестирование Ansible ролей с использованием Molecule и TestInfra
 - В шаблонах Packer включено использование Ansible ролей вместо плейбуков
 - Ansible роль db была вынесена в отдельный git репозиторий [ansible-role-mongodb](https://github.com/EugRomanchenko/ansible-role-mongodb)
 - Для нее было настроено тестирование посредством запуска тестов с помощью Molecule и TravisCI в GCE

### Как запустить проект:
 - Склонировать данный git репозиторий
 - Перейти в директорию ansible и установить отдельную Ansible роль db
```
ansible-galaxy install -r environment/stage/requirements.yml
```
 - Установить Vagrant
 - Из директории ansible запустить
```
vagrant up
```
 
### Как проверить работоспособность:
 - После запуска инфраструктуры с помощью Vagrant перейти в веб браузере по ссылке http://10.10.10.20:9292 и убедиться, что приложение работает
 - Для задания со * после запуска инфраструктуры с помощью Vagrant перейти в веб браузере по ссылке http://10.10.10.20 и убедиться, что приложение работает
 - Для задания со * необходимо убедится, что последний билд [ansible-role-mongodb](https://github.com/EugRomanchenko/ansible-role-mongodb) был успешен и что о нем была отправлена нотификация в Slack канал #eugeny_romanchenko
