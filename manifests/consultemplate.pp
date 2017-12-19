# == Class contoso_hashicorp::consultemplate
#
# This class is meant to be called from contoso_hashicorp.
# It sets up consul.
#

class contoso_hashicorp::consultemplate (
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
