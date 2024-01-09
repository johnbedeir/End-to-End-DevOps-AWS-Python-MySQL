#!/bin/bash

aws ecr list-images --repository-name $1 --region $2 --query 'imageIds[*]' --output json | \
jq -r '.[] | @base64' | \
while read -r image_id_base64; do
    image_id=$(echo $image_id_base64 | base64 --decode)
    echo "Deleting image: $image_id"
    aws ecr batch-delete-image --repository-name $1 --region $2 --image-ids "imageDigest=$(echo $image_id | jq -r .imageDigest)"
done
