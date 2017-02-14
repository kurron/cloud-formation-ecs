#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-ECS}
PROJECTNAME=${2:-Weapon-X}
SECURITYGROUPS=${3:-sg-2d0d7955}
SUBNETS=${4:-subnet-ac62a8e5,subnet-1ae3507d,subnet-af62a8e6,subnet-1be3507c}
INSTANCETYPE=${5:-m4.large}
SPOTPRICE=${6:-0.025}
ENVIRONMENT=${7:-development}
CREATOR=${8:-CloudFormation}
TEMPLATELOCATION=${9:-file://$(pwd)/ecs.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=InstanceType,ParameterValue=$INSTANCETYPE \
                                                     ParameterKey=SpotPrice,ParameterValue=$SPOTPRICE \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                                     ParameterKey=SecurityGroups,ParameterValue=\"$SECURITYGROUPS\" \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
