#FIRST we have to copy the provider , multi_cloud, tfvars files

copy multi_cloud.tf.example multi_cloud.tf
copy providers.azure_gcp.tf.example providers.azure_gcp.tf
copy terraform.tfvars.example terraform.tfvars


#Then Edit the tfvars files 

enable_aws   = true
enable_azure = true
enable_gcp   = true
gcp_project_id = "your-gcp-project-id"
azure_subscription_id = "your-azure-subscription-id"  # optional if using az login

#Run the Terraform Code

terraform init -upgrade
terraform apply
terraform output calculator_urls