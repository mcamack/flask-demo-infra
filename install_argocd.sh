# Install argocd manifest
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expost the argocd-server publicly
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
