# == Class: contoso_hashicorp
#
# Installs, configures, and manages Hashicorp tools for Lantern
#

class contoso_hashicorp (
  String $consul_version = lookup ('consul_version'),
  Array $consul_servers = lookup ('consul_servers'),
  String $consul_acldatacenter = lookup ('consul_acldatacenter'),
  String $consul_datacenter = lookup ('consul_datacenter'),
  String $consul_encrypt = lookup ('consul_encrypt'),
  String $consul_master_token = lookup ('consul_master_token'),
  String $consul_agent_token = lookup ('consul_agent_token'),
  Array $consul_masterdatacenterservers = lookup ('consul_masterdatacenterservers'),
  String $consultemplate_version = lookup ('consultemplate_version'),
  String $consultemplate_token = lookup ('consultemplate_token'),
  String $nomad_version = lookup('nomad_version'),
  String $nomad_datacenter = lookup('nomad_datacenter'),
  Array $nomad_servers = lookup('nomad_servers'),
  String $nomad_metatags = lookup('nomad_metatags'),
  String $vault_servicename = lookup('vault_servicename'),
  Integer $vault_port = lookup('vault_port'),
  # String $vault_version,
  # String $vault_user,
  # String $vault_mode,
) {

  #add resize script to root home
  file { '/root/resize.sh' :
    ensure  => 'file',
    content => file('contoso_hashicorp/resize.sh'),
    mode    => '0755',
  }

  #run through all base installations
  class { '::contoso_hashicorp::consultemplate':
    consultemplate_version => $consultemplate_version,
    consultemplate_token   => $consultemplate_token,
    consul_acldatacenter   => $consul_acldatacenter,
    vault_servicename      => $vault_servicename,
    vault_port             => $vault_port,
  }

  class { '::contoso_hashicorp::consul':
    consul_version                 => $consul_version,
    consul_servers                 => $consul_servers,
    consul_acldatacenter           => $consul_acldatacenter,
    consul_datacenter              => $consul_datacenter,
    consul_encrypt                 => $consul_encrypt,
    consul_master_token            => $consul_master_token,
    consul_agent_token             => $consul_agent_token,
    consul_masterdatacenterservers => $consul_masterdatacenterservers,
  }

  class { '::contoso_hashicorp::nomad':
    nomad_version     => $nomad_version,
    nomad_datacenter  => $nomad_datacenter,
    nomad_servers     => $nomad_servers,
    nomad_metatags    => $nomad_metatags,
    consul_datacenter => $consul_datacenter,
    vault_servicename => $vault_servicename,
    vault_port        => $vault_port,
  }

}
