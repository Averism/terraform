module "static" {
    source = "./modules/S3public"
    domain = local.domain
}
