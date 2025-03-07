module "eks" {
  source            = "terraform-aws-modules/eks/aws"
  version           = "17.24.0"
  cluster_name      = "my-cluster"
  cluster_version   = "1.21"
  subnets           = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  vpc_id            = "vpc-1234556abcdef"
}

module "aks" {
  source                  = "Azure/aks/azurerm"
  kubernetes_version      = "1.21"
  resource_group_name     = "myResourceGroup"
  dns_prefix              = "myakscluster"
}

module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google"
  project_id              = "my-project"
  name                    = "my-gke-cluster"
  regional                = true
  region                  = "us-central1"
}
