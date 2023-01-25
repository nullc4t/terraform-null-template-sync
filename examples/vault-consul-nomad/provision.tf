module "config_generator" {
  source = "../../modules/config-generator"

  input  = {
    nomad-client-prerequisites   = module.nomad-client-prerequisites
    consul-config                = module.consul-config
    vault-config                 = module.vault-config
    nomad-config                 = module.nomad-config
    nomad-client-config          = module.nomad-client-config
    consul-agent-config          = module.consul-agent-config
    consul-dns-forwarding-config = module.consul-dns-forwarding-config
  }
}

//noinspection HILUnresolvedReference
module "config" {
  source      = "../.."

  for_each    = module.config_generator.config
  connection  = each.value.connection
  exec_before = each.value.exec_before
  template    = each.value.template
  exec_after  = each.value.exec_after
}
