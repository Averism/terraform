module "static" {
    source = "./modules/S3public"
    domain = local.domain
    subdomain = "www"
    alias = "static"
}

module "media" {
    source = "./modules/S3public"
    domain = local.domain
    subdomain = "media"
}

module "devs3" {
    source = "./modules/S3public"
    domain = local.domain
    subdomain = "devstaticrepo"
}