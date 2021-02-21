module user {
    source = "./modules/user"
    appname = local.appname
    verification_email_arn = module.email.noreply_email_arn
}