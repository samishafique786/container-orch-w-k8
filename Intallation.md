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

Note: The [main.tf](https://github.com/samishafique786/container-orch-w-k8s/blob/main/terraform/main.tf) file has all the Infrastructure as Code (IaC) via Terraform.  
