# Cloud landing zone

Cloud Folders and IAM creds for running solutions and appliances.

- Dedicated Cloud Folder
- Terraform state S3 buckets
- IAM creds for accessing the bucket

## Usage
The statefile is store locally. Make sure you keep it.
All other state files are stored in S3.

Get access credentials using the following comands:
```commandline
terraform output -json | jq .terraform_access_key.value
export AWS_ACCESS_KEY_ID="......"

terraform output -json | jq .terraform_secret_key.value
export AWS_SECRET_KEY="........"
```
For permanenet configuration using http://direnv.net is recommended.

## TODOs
 - Root DNS zone
 - Cross-folder federation (?)
 - Usage guide
 - Deployment guide
