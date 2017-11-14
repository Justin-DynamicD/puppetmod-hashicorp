# == Class puppetmod-hashicorp::consultemplate
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets up consul.
#

class puppetmod-lantern_hashicorp::consultemplate (
  String $consultemplate_executable,
  String $consultemplate_version,
  String $consultemplate_lchecksum,
  String $consultemplate_wchecksum,
  String $consultemplate_type,
  String $consul_acldatacenter,
  ) {

  #Install Consul-Template
  class { 'consul_template':
    service_enable   => true,
    vault_enabled    => true,
    vault_address    => "http://active.lv-vault.service.${consul_acldatacenter}.consul:8200",
    vault_token      => 'b83a3dfd-361d-d4e9-a9b5-bdbd532e35ae',
    vault_ssl        => false,
    vault_ssl_verify => false,
    consul_wait      => '5s:30s',
  }
}
