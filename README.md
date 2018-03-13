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
