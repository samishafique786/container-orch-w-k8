# Setting Up Networking and Virtual Machines

This section outlines the necessary steps to configure networking components, define security groups, and set up virtual machines for your Kubernetes cluster. Follow these instructions to create a secure and efficient environment for container orchestration.

## Creating Networks

### Public Network (kube-public)

- Create a public network and name it **kube-public**.

### Create a Private Network **kube-private**

- Create a new network:
  - Network address: 192.168.2.0/24
  - Check "Disable Gateway"
  - Check "Enable DHCP"


## Defining Security Groups

1. **Security Group 1:**
   - Allow all incoming SSH, HTTP, HTTPS traffic (0.0.0.0/0)
   - Allow all incoming TCP traffic from kube-public network (192.168.1.0/24)

2. **Security Group 2:**
   - Allow all incoming TCP traffic from kube-public network (192.168.1.0/24)
   - Allow all incoming TCP traffic from kube-private network (192.168.2.0/24)
   - Allow all incoming UDP traffic from kube-private network (192.168.2.0/24)


## Creating Virtual Machines

1. **Rancher Server:**
   - Name: rancher-server
   - Flavor: standard.medium
   - OS: Ubuntu 20.04
   - Networks: internet, kube-public
   - Security Groups - Security Group 1

2. **Kubernetes Master:**
   - Name: kube-master
   - Flavor: standard.medium
   - OS: Ubuntu 20.04
   - Networks: kube-public, kube-private
   - Roles: Master (etcd, control plane, worker)
   - Security Groups - Security Group 2

3. **Kubernetes Worker A:**
   - Name: kube-worker-a
   - Flavor: standard.tiny
   - OS: Ubuntu 20.04
   - Networks: kube-public, kube-private
   - Roles: Worker (worker)
   - Security Groups - Security Group 2

4. **Load Balancer:**
   - Name: load-balancer
   - Flavor: standard.tiny
   - OS: Ubuntu 20.04
   - Networks: internet, kube-public
   - Security Groups - Security Group 1

Note: The [main.tf](https://github.com/samishafique786/container-orch-w-k8s/blob/main/terraform/main.tf) file has all the Infrastructure as Code (IaC) that you can use to deploy.

# Persistent Storage & Docker Installing 

## Persistent Storage 

The are many ways to do so, it depends on the cloud provider you are using. In my case, I am using the **CSC cloud** provider in Finland. 

First, create a persistant volume (in my case 50 GB), and attach it to the VM (load-balancer), as we will be running the load-balancer VM as a "Load Balancer" and "NFS Server."



## Docker

After your virtual machines are up and running, the first thing you need to do is to install docker on all of them, because we will be running NGINX, Pacman, and the OpenCard application as a docker container. You can either do that by SSHing into the VMs, or you can use a 'playbook' if you have Ansible installed and configured.

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl status docker
```
After you confirm that Docker is up and running, you need to add your current Ubuntu user to the docker group.

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Repeat these steps on all the 4 VMs.

# Install Rancher UI on the VM: rancher-server

Well, Since we installed docker on all the VMs, you may have guessed that we will be running Rancher as a Docker container. SSH into the rancher-server VM, and run the following command to bind port 443 for rancher.

```bash
docker run -d --restart=unless-stopped \
  -p 443:443 \
  --privileged \
  rancher/rancher:latest
```

After you run this command on the rancher-server VM, you will see that you are running Rancher on the port 443.

run the command, ``` docker ps ``` and see if you get the following output:

![image](https://github.com/samishafique786/container-orch-w-k8s/assets/108603607/37e72aa1-dbc6-4061-8a5d-542d982eb3a6)

Now that you've installed Rancher, access the Rancher web UI in your browser, and check the bootstrap password. Note: It is recommended that you use a long, specific password. After you've installed Rancher, it is time to create your own **custom Kubernetes cluster**.

# Creating a Custom Kubernetes Cluster

![image](https://github.com/samishafique786/container-orch-w-k8s/assets/108603607/1d180bf5-e724-45b0-b9c1-c7c5f703536e)

After you are on the Homepage of the Rancher Web UI, click on **☰ > Cluster Management** , and then, on the **Clusters** page, click on **Create**. on the right-side corner.

