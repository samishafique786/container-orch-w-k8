# K8sviz and Drawing Kubernetes Architectural Diagrams
For further understanding of our Kubernetes cluster, I used a tool called 'k8sviz' from this [repository.]([url](https://github.com/mkimuram/k8sviz#bash-script-version-1)https://github.com/mkimuram/k8sviz#bash-script-version-1).
With k8sviz, you can easily understand the relationships between your deployments, pods, services, and other resources, all presented in a clear and informative diagram.

Since we have deployed multiple containers and different services with ingress, the understanding of how everything is connected is crucial.

# Prerequisites for K8sviz

### A running Kubernetes cluster
### kubectl configured to access your cluster

## Installation:

```There are two ways to install k8sviz: Bash Script Version & Pre-Built Binary // I used the bash script version.```

1. Just download k8sviz.sh file and add execute permission. [Source: Github (mkimuram)]

```bash
curl -LO https://raw.githubusercontent.com/mkimuram/k8sviz/master/k8sviz.sh
chmod u+x k8sviz.sh
```

2. Deployment in the default namespace
Generate dot file for namespace ```default```
  
```bash
./k8sviz.sh -n default -o default.dot
```
3. Generate png file for namespace ```default```
```bash
./k8sviz.sh -n default -t png -o default.png
```
```A default.png file will be generated in the current working directory where you can see the architectural diagram for your Kubernetes cluster```

![default](https://github.com/samishafique786/container-orch-w-k8s/assets/108603607/86a6d020-5593-468c-8832-ef6ac199d87b)
