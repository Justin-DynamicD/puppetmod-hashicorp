# == Class puppetmod-hashicorp::consultemplate
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets up consul.
#

class lantern_hashicorp::consultemplate (
  String $consultemplate_version,
  String $consultemplate_token,
  String $consul_acldatacenter,
  ) {

  #Install Consul-Template
  class { 'consul_template':
    service_enable   => true,
    vault_enabled    => true,
    vault_address    => "http://active.lv-vault.service.${consul_acldatacenter}.consul:8200",
    vault_token      => $consultemplate_token,
    vault_ssl        => false,
    vault_ssl_verify => false,
    consul_wait      => '5s:30s',
  }
}
