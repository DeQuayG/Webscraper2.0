# Building the Infrastructure:
In order to build the Backend Infrastructure that is written in Terraform, you can manually `cd` into the `IaC\modules\aws\main`  directory, or you can use `make infra` (You can inspect what that does from the Makefile in the root)


### **Known Issues**
# Karpenter CRD:
- Ensure CRD's are installed for Karpenter using:
         `kubectl apply -f https://raw.githubusercontent.com/aws/karpenter/v0.30.0/pkg/apis/crds/karpenter.sh_provisioners.yaml
          kubectl apply -f https://raw.githubusercontent.com/aws/karpenter/v0.30.0/pkg/apis/crds/karpenter.sh_machines.yaml
          kubectl apply -f https://raw.githubusercontent.com/aws/karpenter/v0.30.0/pkg/apis/crds/karpenter.k8s.aws_awsnodetemplates.yaml`