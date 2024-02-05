#!/bin/bash

# Variables
cluster_name="cluster-1-test"
region="eu-central-1"
aws_id="702551696126"
cd terraform 
app_img=$(terraform output -raw ecr_app_repository_name) 
db_img=$(terraform output -raw ecr_db_repository_name)
elastic_ip_name=$(terraform output -raw 
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
./ecr-imgs-delete.sh $app_img $region 
./ecr-imgs-delete.sh $db_img $region 


# Release Elastic IP
echo "--------------------Releasing Elastic IP--------------------"
allocation_id=$(aws ec2 describe-addresses --region $region --filters "Name=tag:Name,Values=${cluster_name}-nat-eip" --query 'Addresses[].AllocationId' --output text)
if [ ! -z "$allocation_id" ]; then
    aws ec2 release-address --allocation-id $allocation_id --region $region
fi

# Destroy Infrastructure
# echo "--------------------Destroy Infrastructure--------------------"
cd terraform && \ 
terraform destroy -auto-approve

# Delete rds snapshot
echo "--------------------Delete Rds Snapshot--------------------"
aws rds delete-db-cluster-snapshot --db-cluster-snapshot-identifier $rds_snapshot_name --region $region

# Destroy the remaning infrastructure
echo "--------------------Destroy Remaining Infrastructure--------------------"
terraform destroy -auto-approve
