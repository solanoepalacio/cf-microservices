#!/bin/bash

PROJECT_ROOT=$(pwd)
source common.env

cd $(dirname "$0")

source .env

NODE_SERVER_USER_DATA_SCRIPT=$PROJECT_ROOT/common-resources/ec2-node-server-userdata.sh

aws cloudformation create-stack --stack-name $STACK_NAME \
    --template-body file://aws-infrastructure.yml \
    --parameters \
        ParameterKey=EC2KeyName,ParameterValue=$EC2_KEY_NAME \
        ParameterKey=NodeServerUserData,ParameterValue=$(base64 -w0 $NODE_SERVER_USER_DATA_SCRIPT) 


# aws cloudformation create-stack \
#     --stack-name $STACK_NAME \
#     --template-body file://aws-infrastructure.yml \
    # --parameters \
        # ParameterKey=EC2KeyName,ParameterValue=$EC2_KEY_NAME \
        # ParameterKey=NodeServerUserData,ParameterValue=$(base64 -w0 $NODE_SERVER_USER_DATA_SCRIPT) \