Ultimate project workflow:
1. terraform : create ec2 with ansible.
2. setup ansible to work with localhost ec2 instance which we created with terraform. Configure/install kubectl,eksctl,awscli,docker,maven and jenkins to the localhost ec2 and with out anisble playbook yaml.
3. Run aws configure as both ubuntu and jenkins user. And finish jenkins setup with two plugins docker pipeline, kubernetes plugin. Al;so add dockerhub credentials and kubeconfig credentials in jenkins global credentials section.
4. create eks cluster and nodegroup with eksctl and Follow with the IAM oidc provcider,role,policy steps - which is needed by ingress/LB.  and connect our ec2 to our eks cluster. 
5. eksctl also creates vpc and a few security groups, so at this point please allow inbound rules for all traffic or as per requirement for seemless configuration and access to our app.
5. configiure jenkins plugins and setup k8s cloud and test jenkins-eks connectivity.
6. Run jenkins pipeline(requires maven) and deploy our app to the eks cluster.
7. access alb endpoint to access the eks load balanced APP.



