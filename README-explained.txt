--ection 1--
goal: "terraform : create ec2 with ansible,kubectl,eksctl,awscli installed as ec2 user-data." 
$ terraform init; terraform plan ; terraform apply

--section 2--
goal: "setup ansible to work with localhost ec2 instance which we created with terraform. Configure,docker,maven and jenkins to the localhost ec2 and with out anisble playbook yaml."
$ aws configure <-- aws iam user admin credentials
Run ansible playbook to configure docker, maven and jenkins: # ansible-playboook playbook.yaml
Create the EKS cluster with it's working nodegroups and verify with kubectl get nodes:
$ bash eksctl.sh

--section 3--
"IAM Roles and Policies"
- download policy:
$ curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
- create policy:
$ aws iam create-policy --policy-name capstone-pol --policy-document file://iam_policy.json
- create role:
$ aws iam create-role --role-name capstone-role --region us-east-1 --assume-role-policy-document file://trust_policy.json
- attaches policy to role:
$ aws iam attach-role-policy --role-name capstone-role -arn:aws:iam::113895760252:policy/capstone-pol --region us-east-1 --output text


--section 4--
create iamserviceaccount , cert-manager and download ingtress.yaml change a few things and apply:
$ eksctl create iamserviceaccount --cluster=capstone-eks-cluster --name=aws-load-balancer-controller --namespace=kube-system --attach-policy-arn=arn:aws:iam::<confidential-acc-id>:policy/test-capstonr-pol --region=us-east-1 --override-existing-serviceaccounts --approve

$ kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.12.7/cert-manager.yaml
$ curl -Lo ingress-controller.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.1/v2_4_1_full.yaml
edit the followign two place - cluster-name and add annotation eksrole arn in kind: ServiceAccount section in the ingress_controller.yaml
spec:
    containers:
    - args:
        - --cluster-name=<cluster-name> # edit the cluster name
        - --ingress-class=alb

Update only the ServiceAccount section (E.G: ARN) of the file only. 
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  annotations:                                                                        # Add the annotations line
    eks.amazonaws.com/role-arn:  arn:aws:iam::11388765322987:role/eksctl-capstone-eks-addon-iamserviceaccount-k-Role1-w1A2RSCEdqmS              # Add the IAM role
  name: aws-load-balancer-controller
  namespace: kube-system

$ kubectl apply -f ingress-controller.yaml , run this twice. for ingress to work properly.

verify:
$ kubectl describe ingress aws-load-balancer-controller -n kubesystem
Now as soon as we deploy our app with deployment,service and ingress.yaml for k8s configured, above setups will automatically create the AWS ALB as a single endpoint for our app for the custoemers to access.

--section 5--
Connecting jenkisn to eks and Deploymnent of app with auto creation of aws ALB/ CI-CD:
Now open jenkins. install the neccessary plugins: "kubernetes and docker pipeline", setup a cloud and Connect to the eks cluster, cluster ep can be found in the ~/.kube/config file. 
for global credentials: use the kubeconfig as secretfile to conenct to the eks cluster from jenkins server and use dockerhub username-password for dockercred.

customer ready:
access the app at alb dns endpoint e.g: http://k8s-citibank-ingressc-117e0f696f-2048389251.us-east-1.elb.amazonaws.com/


optionals: 
For our build to work, copy the kubectonfig file to /var/lib/jenkins/.kube/config and chown jenkins:jenkins to it.
if docker requires sudo just restart the jenkins service only once.


Clean UP resources:
cleanup:
eksctl delete nodegroup workers --cluster=capstone-eks --region=us-east-1
eksctl delete cluster capstone-eks --region=us-east-1
terraform destroy


