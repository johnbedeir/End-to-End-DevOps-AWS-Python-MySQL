#!/bin/bash

# Variables
cluster_name="cluster-1-test"
region="eu-central-1"
aws_id="702551696126"
repo_name="todo-list" # If you wanna change the repository name make sure you change it in the k8s/app.yml (Image name) 
db_repo="todo-db"
image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$repo_name:latest"
db_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$db_repo:latest"
domain="johnydev.com"
namespace="todo-app"
# End Variables

# update helm repos
# helm repo update

# create the cluster
# echo "--------------------Creating EKS--------------------"
# echo "--------------------Creating ECR--------------------"
# echo "--------------------Creating EBS--------------------"
# echo "--------------------Deploying Ingress--------------------"
# echo "--------------------Deploying Monitoring--------------------"
# cd terraform && \ 
# terraform init 
# terraform apply -auto-approve
# cd ..

# update kubeconfig
echo "--------------------Update Kubeconfig--------------------"
aws eks update-kubeconfig --name $cluster_name --region $region

# remove preious docker images
echo "--------------------Remove Previous build--------------------"
docker rmi -f $image_name || true
docker rmi -f $db_image_name || true

# build new docker image with new tag
echo "--------------------Build new Image--------------------"
docker build -t $image_name todo-app/
docker build -f k8s/Dockerfile.mysql -t $db_image_name k8s/

#ECR Login
echo "--------------------Login to ECR--------------------"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_id.dkr.ecr.eu-central-1.amazonaws.com

# push the latest build to dockerhub
echo "--------------------Pushing Docker Image--------------------"
docker push $image_name
docker push $db_image_name

# create namespace
echo "--------------------creating Namespace--------------------"
kubectl create ns $namespace || true

# Deploy the application
echo "--------------------Deploy App--------------------"
kubectl apply -n $namespace -f k8s

# # Wait for application to be deployed
# echo "--------------------Wait for all pods to be running--------------------"
# sleep 60s

# # Get ingress URL
# echo "--------------------Ingress URL--------------------"
# kubectl get ingress todo-app-ingress -n $namespace -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
# echo " "
# echo " "
# echo "--------------------Application URL--------------------"
# echo "http://todo.$domain"

# echo "--------------------Alertmanager URL--------------------"
# echo "http://alertmanager.$domain"
# echo " "

# echo "--------------------Prometheus URL--------------------"
# echo "http://prometheus.$domain"
# echo " "

# echo "--------------------Grafana URL--------------------"
# echo "http://grafana.$domain"
# echo " "
# echo " "

# echo -e "1. Navigate to your domain cpanel.\n2. Look for Zone Editor.\n3. Add CNAME Record to your domain.\n4. In the name type domain for your application.\n5. In the CNAME Record paste the ingress URL."