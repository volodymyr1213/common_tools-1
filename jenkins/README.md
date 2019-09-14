Table of Contents
=================

* [JenkinsCluster](overview#JenkinsCluster---terraform)
    * [PreRequisite](#markdown-header-prerequisite)
    * [Creating K8s cluster](#creating-k8s-cluster)
        * [Clone infrastructure repo to your workspace](README.md#clone-infrastructure-repo-to-your-workspace)
        * [Get latest files](README.md#get-latest-files)
        * [Setting up your environment](README.md#setting-up-your-environment)
        * [Running terraform](README.md#running-terraform)

# JenkinsCluster

#### PreRequisite

- Access to  https://coderepository.mcd.com/scm/vet/scripts.git
- Access to DAC server (10.1.4.64)
  - Tools already setup
    - Docker 
    - Git
- Access to the private key for a team level DAC user. Name it to `<TEAM>-dac-user.pem` so it's easy to identify
- A Running Kubernetes Cluster with a remote state file created see [infrastructure](https://coderepository.mcd.com/projects/VET/repos/infrastructure/browse) for details. 
- Basic understanding of how [terraform](https://www.terraform.io/intro/index.html) works

```
#Example SSH command
ssh -i <TEAM>-dac-user.pem <TEAM>-dac-user@10.1.4.64
```

- You have access to run terraform via AWS-GG-VET-TFUser AWS Role. This can be verified by logging into [AWS CORP account](https://gafs.mcd.com/adfs/ls/idpinitiatedsignon.aspx?logintoRP=urn:amazon:webservices)

#### Adding Jenkins to a K8s cluster

##### Clone infrastructure repo to your workspace

- DAC server is accessed by each user using <TEAM>-dac-user so you will need to create your own workspace

```
cd ~
mkdir <firstname.lastname>
cd <firstname.lastname>
git clone https://coderepository.mcd.com/scm/vet/scripts.git
git clone https://coderepository.mcd.com/scm/vet/cluster-tools.git
cd cluster-tools/kops
```

##### Get latest files

- Get the latest files when changes are made in the repo

```
git pull

# Check which branch you are in
git status
```

##### Setting up your environment

- Please perform the following steps to ensure your statefile is updated correctly for the environment you are working on and install any preprequisites
State files exist for each environment that has configurations for. As of this writing terraform doesn't support variable substitution for s3 backend. [issue-link](https://github.com/hashicorp/terraform/issues/13022) 

- Cleanup files (DO NOT DO THIS IF YOU ARE UNSURE OF WHAT IT DOES)

```
# USE CAUTION WHILE RUNNING BELOW COMMAND
rm infrastructure/*/terraform.tfstate
```
- Create configurations if you want a new environment inside `configurations` folder following the existing structure

- Get temporary credentials (This applies only for McD account that has AWS SSO configuration)

```
## You should have infrastructure repo and scripts repo in the same directory for below command to work. 
## Go back to prerequisites to clone the scripts repo

cd ../../../scripts && export PATH=$PATH:$(pwd) && cd -
```

- Set configuration variables

```
#Make sure you are in cluster-tools/kops folder
source ./setenv configurations/<AWS_ACCOUNT_ALIAS>/<AWS_REGION>/<ENVIRONMENT>.tf

#Example - if you want to work on dev1 environment in corp account.
source ./setenv configurations/corp/us-east-1/uskops1.tf

```

##### Running terraform

- Check your backend configuration file contents and make sure it's pointing to correct s3 bucket location to store terraform state

```
cat backend.tf
cat .terraform/terraform.tfstate | jq .backend.config
# if both files aren't matching, then you will have to cleanup the .terraform folder. USE CAUTION IF YOU HAVE LOCAL STATE
```

- Run terraform plan to review what changes you are going to make

```
terraform plan --var-file=$DATAFILE
```

- Run terraform apply if you are satisfied with the output of the plan command

```
terraform apply --var-file=$DATAFILE
```

- Wait until all your nodes are online and in a ready state. This is going to take about 10-15 minutes

```

# Example
export NAME=dev1.rndecp.net
export KOPS_STATE_STORE=s3://rnd-tfstate/vet/us-east-1/sharedtools/dev1

kops validate cluster --state ${KOPS_STATE_STORE} --name ${NAME}
kubectl get nodes -a
kubectl cluster-info|grep master
kops get secrets kube --type secret -oplaintext
```

##### Destroying cluster

```
terraform destroy --var-file=$DATAFILE
```

##### Troubleshooting

