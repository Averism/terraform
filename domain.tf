provider "aws" {
    region = "ap-southeast-1"
    }
    
module "domain" {
    source = "./modules/hostedzone"
    domain = "averism.com"
}
