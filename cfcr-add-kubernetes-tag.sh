#!/bin/bash
set -e

for subnet_id in `aws ec2 describe-subnets --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=bbl-env*" | jq -r '.[][].SubnetId'`;do
	aws ec2 create-tags --resources ${subnet_id} --tags Key=KubernetesCluster,Value=cfcr
done

