module email {
    source = "./modules/email"
    zone_id = module.domain.id
    domain = local.domain
}