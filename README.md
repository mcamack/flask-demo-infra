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

## Install ALB Controller for Ingress
* First, attach the policy which fixes this issue (https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.5/docs/examples/iam-policy.json) to the EKS worker nodes
* kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.2/cert-manager.yaml
* curl -o v2_1_2_full.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.2/docs/install/v2_1_2_full.yaml
  * change "cluster-name" to the new EKS cluster name
  * kubectl apply -f v2_1_2_full.yaml

## CodeBuild Webhooks
The codebuild.tf file contains a webhook that can only be created after the CodeBuild Project has its Source connected to Github. This 
can be manually done by logging in to the AWS console and updating this project's Source to "Connect to Github" which requires a login. 
Once completed, the webhook resource in codebuild.tf will be created successfully and pushes to the source repo will trigger a build of 
the docker image.

## Install ArgoCD
`./install_argocd.sh` will create the `argocd` namespace and install within it

Login to the ArgoCD UI:
* export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output .status.loadBalancer.ingress[0].hostname`
* export ARGO_PWD=`kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2`
* Go to the URL of $ARGOCD_SERVER and login as user: `admin` with password: `$ARGO_PWD`