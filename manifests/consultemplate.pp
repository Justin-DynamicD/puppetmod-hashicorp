# == Class lantern_hashicorp::consultemplate
#
# This class is meant to be called from lantern_hashicorp.
# It sets up consul.
#

class lantern_hashicorp::consultemplate (
  String $consultemplate_version,
  String $consultemplate_token,
  String $consul_acldatacenter,
  String $vault_servicename,
  Integer $vault_port,
  ) {

  #Install Consul-Template
  class { 'consul_template':
    service_enable   => true,
    vault_enabled    => true,
    vault_address    => "https://${vault_servicename}.ad.lanterncredit.com:${vault_port}",
    vault_token      => $consultemplate_token,
    vault_ssl        => true,
    vault_ssl_verify => true,
    consul_wait      => '5s:30s',
  }
}
