# flask-demo-infra
Bootstrap code to get an EKS cluster running

Resources:
EKS TF guide: https://learn.hashicorp.com/tutorials/terraform/eks

## Setup
Run `terraform init` to setup the providers

## Run
Running `terraform apply` will create the EKS cluster

Add this cluster to your kubeconfig using:
`aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

`kubectl get nodes` should now return:
```
NAME                                      STATUS   ROLES    AGE    VERSION
ip-10-0-1-22.us-west-2.compute.internal   Ready    <none>   8m8s   v1.18.9-eks-d1db3c
ip-10-0-2-50.us-west-2.compute.internal   Ready    <none>   8m6s   v1.18.9-eks-d1db3c
```

## Install some Tools
`./install_argocd.sh` will create the `argocd` namespace and install within it