#!/bin/bash

# Variables
cluster_name="cluster-1-test"
region="eu-central-1"
aws_id="702551696126"
cd terraform 
app_img=$(terraform output -raw ecr_app_repository_name) 
db_img=$(terraform output -raw ecr_db_repository_name)
rds_endpoint=$(terraform output -raw rds_cluster_endpoint)
db_username=$(terraform output -raw db_username)
db_password=$(terraform output -raw db_password)
app_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$app_img:latest"
db_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$db_img:latest"
cd ..
namespace="todo-app"
monitoring_ns="monitoring"
app_service_name="todo-app-service"
alertmanager_service_name="kube-prometheus-stack-alertmanager"
prometheus_service_name="kube-prometheus-stack-prometheus"
grafana_service_name="kube-prometheus-stack-grafana"
# End Variables

# update helm repos
helm repo update

# create the cluster
# echo "--------------------Creating EKS--------------------"
# echo "--------------------Creating ECR--------------------"
# echo "--------------------Creating EBS--------------------"
# echo "--------------------Creating RDS--------------------"
# echo "--------------------Deploying Monitoring--------------------"
cd terraform && \
terraform init 
terraform apply -auto-approve
cd ..

# update kubeconfig
echo "--------------------Update Kubeconfig--------------------"
aws eks update-kubeconfig --name $cluster_name --region $region

# remove preious docker images
echo "--------------------Remove Previous build--------------------"
docker rmi -f $app_image_name || true
docker rmi -f $db_image_name || true

# build new docker image with new tag
echo "--------------------Build new Image--------------------"
# docker build -t $app_image_name todo-app/
docker build -t $db_image_name -f k8s/Dockerfile.mysql k8s

# ECR Login
echo "--------------------Login to ECR--------------------"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_id.dkr.ecr.eu-central-1.amazonaws.com

# push the latest build to dockerhub
echo "--------------------Pushing Docker Image--------------------"
docker push $app_image_name
docker push $db_image_name

# create namespace
echo "--------------------creating Namespace--------------------"
kubectl create ns $namespace || true

# add rds endpoint into k8s secrets
echo "--------------------Create RDS Secrets --------------------"
kubectl create secret -n $namespace generic rds-endpoint --from-literal=endpoint=$rds_endpoint || true
kubectl create secret -n $namespace generic rds-username --from-literal=username=$db_username || true
kubectl create secret -n $namespace generic rds-password --from-literal=password=$db_password || true

# deploy the application
echo "--------------------Deploy App--------------------"
kubectl apply -n $namespace -f k8s/

# Wait for application to be deployed
echo "--------------------Wait for all pods to be running--------------------"
sleep 60s

# Get ingress URL
echo "--------------------Application LoadBalancer URL--------------------"
kubectl get svc -n ${namespace} ${app_service_name} -o=custom-columns=EXTERNAL-IP:.status.loadBalancer.ingress[*].hostname | tail -n +2
echo "-------------------- Alertmanager LoadBalancer URL--------------------"
kubectl get svc -n ${monitoring_ns} ${alertmanager_service_name} -o=custom-columns=EXTERNAL-IP:.status.loadBalancer.ingress[*].hostname | tail -n +2
echo "--------------------Prometheus LoadBalancer URL--------------------"
kubectl get svc -n ${monitoring_ns} ${prometheus_service_name} -o=custom-columns=EXTERNAL-IP:.status.loadBalancer.ingress[*].hostname | tail -n +2
echo "--------------------Grafana LoadBalancer URL--------------------"
kubectl get svc -n ${monitoring_ns} ${grafana_service_name} -o=custom-columns=EXTERNAL-IP:.status.loadBalancer.ingress[*].hostname | tail -n +2

# Get RDS endpoint URL
echo "--------------------RDS endpoint URL--------------------"
echo $rds_endpoint