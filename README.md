#### helpful commands for deployment
create a permissible IAM account and connect your aws cli command line with access keys 
```
terraform init
terraform plan -out play-eks
terraform apply play-eks
```
####test command for the cluster 
after application is complete run the command below for testing the cluster
`kubectl run temp-pod --rm -it --image=busybox -- /bin/sh`

#### clean up 
terraform destroy
