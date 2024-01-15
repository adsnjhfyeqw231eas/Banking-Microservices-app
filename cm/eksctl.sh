#!/bin/bash
# configure eks on aws
eksctl create cluster --name=capstone-eks \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --without-nodegroup
sleep 10
eksctl get clusters --region=us-east-1
sleep 5
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster capstone-eks \
    --approve
sleep 30
eksctl create nodegroup --cluster=capstone-eks \
                        --region=us-east-1 \
                        --name=workers \
                        --node-type=t2.medium \
                        --nodes=2 \
                        --nodes-min=1 \
                        --nodes-max=3 \
                        --node-volume-size=20 \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access
sleep 5
kubectl get nodes
