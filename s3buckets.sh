#!/bin/bash

# Prompt user for AWS credentials and region
read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
read -p "Enter AWS Region (e.g., us-east-1): " AWS_DEFAULT_REGION


# Set AWS CLI credentials for the session
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile temp-profile
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile temp-profile
aws configure set default.region $AWS_DEFAULT_REGION --profile temp-profile


while true; do
    # Display menu options
    echo "Select an option:"
    echo "1. List S3 Buckets"
    echo "2. Copy from Local to S3"
    echo "3. Copy from S3 to Local"
    echo "4. Move from Local to S3"
    echo "5. Move from S3 to Local"
    echo "6. Create presign of S3 file"
    echo "7. Quit"

    # Read user choice
    read -p "Enter option (1-7): " choice

    case $choice in
        1)
            # List S3 Buckets
            read -p "Enter S3 Bucket Name: " bucket_name
            echo "Available S3 Buckets:"
            aws s3 ls s3://$bucket_name --profile temp-profile
            ;;
        2)
            # Copy from Local to S3
            read -p "Enter local file path: " local_path
            read -p "Enter S3 destination path: " s3_path
            aws s3 cp $local_path s3://$s3_path --profile temp-profile
            ;;
        3)
            # Copy from S3 to Local
            read -p "Enter S3 source path: " s3_path
            read -p "Enter local destination path: " local_path
            aws s3 cp s3://$s3_path $local_path --profile temp-profile
            ;;
        4)
            # Move from Local to S3
            read -p "Enter local file path: " local_path
            read -p "Enter S3 destination path: " s3_path
            aws s3 mv $local_path s3://$s3_path --profile temp-profile
            ;;
        5)
            # Move from S3 to Local
            read -p "Enter S3 source path: " s3_path
            read -p "Enter local destination path: " local_path
            aws s3 mv s3://$s3_path $local_path --profile temp-profile
            ;;

        6)
            read -p "Enter s3 bucketname and file name: " s3_path
            aws s3 presign s3://$s3_path
            ;;

        7)
            # Quit
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid option. Please enter a number between 1 and 7."
            ;;
    esac
done
