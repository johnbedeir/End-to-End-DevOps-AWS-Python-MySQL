#!/bin/bash

# Variables
region="eu-central-1"
aws_id="702551696126"
cd terraform 
app_img=$(terraform output -raw ecr_app_repository_name) 
db_img=$(terraform output -raw ecr_db_repository_name)
app_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$app_img:latest"
db_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$db_repo:latest"
rds_snapshot_name=$(terraform output -raw final_snapshot_name)
cd ..
namespace="todo-app"
# End Variables

# remove preious docker images
echo "--------------------Remove Previous build--------------------"
docker rmi -f $app_image_name || true
docker rmi -f $db_image_name || true

# delete Docker-img from ECR
echo "--------------------Deleting ECR-IMG--------------------"
aws ecr batch-delete-image --repository-name $app_image_name --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $db_image_name --image-ids imageTag=latest

# Destroy Infrastructure
# echo "--------------------Destroy Infrastructure--------------------"
cd terraform && \ 
terraform destroy -auto-approve

# Delete rds snapshot
echo "--------------------Delete Rds Snapshot--------------------"
aws rds delete-db-snapshot --db-snapshot-identifier $rds_snapshot_name

# Destroy the remaning infrastructure
echo "--------------------Destroy Remaining Infrastructure--------------------"
terraform destroy -auto-approve




