The NFS subdir external provisioner facilitates the creation of StorageClaims utilizing the storage capacity of an NFS server. 
## Step 1: Install Kubernetes NFS Subdir External Provisioner
1. Install via Helm: Add the NFS Subdir External Provisioner Helm repository:
```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
```
Install the provisioner with custom NFS server and path configurations:
```bash
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.1.18 \
    --set nfs.path=/mnt/my_persistent_volume
```

