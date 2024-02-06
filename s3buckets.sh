#!/bin/bash


install_aws_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y awscli
}

install_aws_macos() {
    brew install awscli
}

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed."

    # Ask the user if they want to install AWS CLI
    read -p "Would you like to install AWS CLI? (y/n): " install_choice

    case $install_choice in
        [Yy])
            # Determine the operating system and install AWS CLI accordingly
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "Installing AWS CLI on Ubuntu..."
                install_aws_ubuntu
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                echo "Installing AWS CLI on macOS..."
                install_aws_macos
            else
                echo "Unsupported operating system. Please install AWS CLI manually."
                exit 1
            fi
            ;;
        [Nn])
            echo "Exiting script. AWS CLI is required for this script to function."
            exit 1
            ;;
        *)
            echo "Invalid choice. Exiting script."
            exit 1
            ;;
    esac
else
    echo "AWS CLI is already installed."
fi


# Prompt user for AWS credentials and region
read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
read -p "Enter AWS Region (e.g., us-east-1): " AWS_DEFAULT_REGION

# While loop for menu options
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
            AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws s3 ls s3://$bucket_name
            ;;
        2)
            # Copy from Local to S3
            read -p "Enter local file path: " local_path
            read -p "Enter S3 destination path: " s3_path
            AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws s3 cp $local_path s3://$s3_path
            ;;
        3)
            # Copy from S3 to Local
            read -p "Enter S3 source path: " s3_path
            read -p "Enter local destination path: " local_path
            AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws s3 cp s3://$s3_path $local_path
            ;;
        4)
            # Move from Local to S3
            read -p "Enter local file path: " local_path
            read -p "Enter S3 destination path: " s3_path
            AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws s3 mv $local_path s3://$s3_path
            ;;
        5)
            # Move from S3 to Local
            read -p "Enter S3 source path: " s3_path
            read -p "Enter local destination path: " local_path
            AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws s3 mv s3://$s3_path $local_path
            ;;
        6)
            # Create presign of S3 file
            read -p "Enter S3 bucket name and file name: " s3_path
            AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws s3 presign s3://$s3_path
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






