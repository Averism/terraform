module "static" {
    source = "./modules/S3public"
    bucketname = "static.${local.domain}"
}
