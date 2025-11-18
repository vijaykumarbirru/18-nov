sudo yum install -y awscli
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin



2)	   eksctl create iamserviceaccount \
         --cluster=eks-backend \
         --namespace=kube-system \
         --name=aws-load-balancer-controller \
         --attach-policy-arn=arn:aws:iam::335082366654:policy/ALBIngressControllerIAMPolicy \
         --override-existing-serviceaccounts \
         --approve

2)	   eksctl create iamserviceaccount \
         --cluster=eks-gateway \
         --namespace=kube-system \
         --name=aws-load-balancer-controller \
         --attach-policy-arn=arn:aws:iam::335082366654:policy/ALBIngressControllerIAMPolicy \
         --override-existing-serviceaccounts \
         --approve