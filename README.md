# FuchiCorp Kubernetes Common Tools
This page contains how to deploy  common_tools to Kubernetes  Cluster. 

### Required Packages
1. terraform
2. kubectl (configured ) 


## What will be deployed to cluster?
1. Jenkins 
Jenkins is will be deployed to the cluster. You will need to get password from the pod [Example doc](https://stackoverflow.com/questions/40570173/installing-jenkins-the-first-time-and-do-not-know-the-default-user-name)

2. Nexus
After deploying the nexus you will need to change the password default creds is  `admin:admin123` 

4. Grafana
Grafana also will be deployed you are able to parse admin username and password with tfvars. Vars `grafana_username`, `grafana_password`

6. Vault 
For Vault you will need to create parse variable for token call it `vault_token`


## Deploy to Cluster 
First you will need to clone the repo 
```
git clone https://github.com/fuchicorp/common_tools.git
cd common_tools
```

Please use default  module just run following command.
```
terraform init 
```

If you are using scripted way you will need to generate tfvars file. For example 

```
» cat <<EOF > my_vars.tfvars                                                                     
grafana_password = 'mypassword'
grafana_username = 'admin_user'
namespace      = 'tools'
vault_token    = 'a872nawd81*q2n'
EOF
```

After you done with generation of the var file. You can start deploying.
```
terraform plan -var-file=my_vars.tfvars    
terraform apply -var-file=my_vars.tfvars
```