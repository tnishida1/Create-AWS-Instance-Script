#!/bin/bash

if [[ ( $2 != "" && $3 != "") ]]; then
    AMI="ami-a042f4d8"
    KEY="$2"
    NAME="$3"
    INSTANCE="$(aws ec2 run-instances --image-id $AMI --count 1 --instance-type t2.micro --key-name $KEY --security-groups jenkins | grep InstanceId)"
    INSTANCE1="$(echo ${INSTANCE} | cut -d " " -f2 | tr -d '"' | tr -d ',')" 
    aws ec2 create-tags --resources ${INSTANCE1} --tags "Key=Name,Value=${NAME}"
    ID="$(aws ec2 describe-instances --instance-id ${INSTANCE1} | grep PublicDnsName | head -1)"
    ID1="$(echo ${ID} | cut -d " " -f2 | tr -d '"' | tr -d ',')" 
    ssh -i ${KEY} -l centos ${ID1}
    #aws ec2 terminate-instances --instance-ids "${INSTANCE1}"
else
    echo "private key and instance name cannot be empty"
fi

