# this determines the name of sgs, the chef node names, and the s3 key that remote state is stored.
environment = "eks2"

s3_bucket = "mcd-vanguard-dev-tfstate" #Will be used to set backend.tf

s3_folder_project = "vet" #Will be used to set backend.tf

s3_folder_region = "us-east-1" #Will be used to set backend.tf

s3_folder_type = "sharedtools" #Will be used to set backend.tf

s3_tfstate_file = "kops_jenkins.tfstate" #Will be used to set backend.tf

# Jenkins Values
jenkins {
  admin_user     = "admin"
  admin_password = "adminMCD"
}
