module "aws_infra" {
  #source = "github.com/arunk4m/vThunder-terraform/tree/master/modules/provider/AWS/infra/compute"
  source = "../../../../../modules/provider/AWS/infra/compute"

}

module "aws_network" {

  source = "../../../../../modules/provider/AWS/infra/network"
}
