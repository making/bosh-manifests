#!/bin/bash
set -e

MASTER_ROLE_NAME=cfcr-master
WORKER_ROLE_NAME=cfcr-worker

cat <<EOF > ${MASTER_ROLE_NAME}.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
cat <<EOF > ${MASTER_ROLE_NAME}-policy.json
{
  "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
          "ec2:CreateTags",
          "ec2:ModifyInstanceAttribute",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DeleteSecurityGroup",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeVpcs",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
}
EOF
cat <<EOF > ${WORKER_ROLE_NAME}.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
cat <<EOF > ${WORKER_ROLE_NAME}-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF


# master
aws iam create-role --role-name ${MASTER_ROLE_NAME} --assume-role-policy-document file://$(pwd)/${MASTER_ROLE_NAME}.json
aws iam attach-role-policy --policy-arn `aws iam create-policy --policy-name ${MASTER_ROLE_NAME} --policy-document file://$(pwd)/${MASTER_ROLE_NAME}-policy.json  | jq -r '.Policy.Arn'` --role-name ${MASTER_ROLE_NAME}
aws iam create-instance-profile --instance-profile-name ${MASTER_ROLE_NAME}
aws iam add-role-to-instance-profile --role-name ${MASTER_ROLE_NAME} --instance-profile-name ${MASTER_ROLE_NAME}
# worker
aws iam create-role --role-name ${WORKER_ROLE_NAME} --assume-role-policy-document file://$(pwd)/${WORKER_ROLE_NAME}.json
aws iam attach-role-policy --policy-arn `aws iam create-policy --policy-name ${WORKER_ROLE_NAME} --policy-document file://$(pwd)/${WORKER_ROLE_NAME}-policy.json  | jq -r '.Policy.Arn'` --role-name ${WORKER_ROLE_NAME}
aws iam create-instance-profile --instance-profile-name ${WORKER_ROLE_NAME}
aws iam add-role-to-instance-profile --role-name ${WORKER_ROLE_NAME} --instance-profile-name ${WORKER_ROLE_NAME}


rm -f ${MASTER_ROLE_NAME}*.json
rm -f ${WORKER_ROLE_NAME}*.json