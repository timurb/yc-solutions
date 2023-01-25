This is a standalone installation of Outline VPN server on Yandex Cloud.

Run terraform apply, then copy the API key from console to Outline Manager, then copy the connection key to your Outline VPN client. That's it.

### Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and configure Cloud, Folder and Subnet IDs there.
Make sure you have Yandex CLI configured and run `export YC_TOKEN=$(yc iam create-token)` prior to running `terraform apply`.

