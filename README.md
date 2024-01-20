# Container Orchestration with Kubernetes

Explore the world of container orchestration using Kubernetes. This project guides you through the deployment of a fully functional Kubernetes cluster and the setup of an e-commerce site, covering essential components and configurations.

# The Architecture in the Cloud

![Kube-sami drawio](https://github.com/samishafique786/container-orch-w-k8s/assets/108603607/708c05eb-f501-42e9-a6b9-6ec05ab9a8e6)


## Key Components:

1. **Networking and Virtual Machines:**
   - Rename and create networks
   - Define security groups
   - Set up virtual machines for Rancher, Kubernetes nodes, and a load balancer

2. **Docker Installation:**
   - Install Docker on virtual machines

3. **Rancher Installation:**
   - Configure Rancher on the designated server
   - Create a custom Kubernetes cluster

4. **Load Balancer Configuration:**
   - Set up Nginx as a load balancer

5. **Workload and Ingress:**
   - Deploy a sample workload (rancher-pacman)
   - Configure Ingress to expose the application outside the cluster

6. **NFS Server:**
   - Install and configure an NFS server for external storage

7. **NFS Subdir External Provisioner:**
   - Set up NFS subdir external provisioner for dynamic provisioning of persistent volumes

8. **OpenCart Deployment:**
   - Use Helm to deploy OpenCart on Kubernetes
   - Configure Nginx ingress for domain mapping
   - Make a sample purchase on the e-commerce site

9. **Final Checks:**
   - Examine hosts files
   - Verify services and check persistent volumes and ingress details

## Note:
This project provides a hands-on experience with container orchestration using Kubernetes, emphasizing components like load balancing, storage management, and dynamic provisioning.

Feel free to customize the project based on your requirements and use it as a learning resource for Kubernetes orchestration.

