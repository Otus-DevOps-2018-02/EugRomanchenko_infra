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
