#!/bin/bash

DIR=$(pwd)
DATAFILE="$DIR/$1"
#
# FuchiCorp common script to set up Google terraform environment variables
# these all variables should be created on your config file before you run script.
# <ENVIRONMENT> <BUCKET> <DEPLOYMENT> <PROJECT> <CREDENTIALS>

if [ ! -f "$DATAFILE" ]; then
  echo "setenv: Configuration file not found: $DATAFILE"
  return 1
fi

wget --quiet -O "$PWD/common_configuration.tfvars"\
  "https://raw.githubusercontent.com/fuchicorp/main-fuchicorp/master/project-configuration/google_account_information.tfvars"


BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'             "$PWD/common_configuration.tfvars")
PROJECT=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'             "$PWD/common_configuration.tfvars")
ENVIRONMENT=$(sed -nr 's/^deployment_environment\s*=\s*"([^"]*)".*$/\1/p'    "$DATAFILE")
DEPLOYMENT=$(sed -nr 's/^deployment_name\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE")
CREDENTIALS=$(sed -nr 's/^credentials\s*=\s*"([^"]*)".*$/\1/p'               "$DATAFILE")

if [ -z "$ENVIRONMENT" ]
then
    echo "setenv: 'deployment_environment' variable not set in configuration file."
    return 1
fi

if [ -z "$BUCKET" ]
then
  echo "setenv: 'google_bucket_name' variable not set in configuration file."
  return 1
fi

if [ -z "$PROJECT" ]
then
    echo "setenv: 'google_project_id' variable not set in configuration file."
    return 1
fi

if [ -z "$CREDENTIALS" ]
then
    echo "setenv: 'credentials' file not set in configuration file."