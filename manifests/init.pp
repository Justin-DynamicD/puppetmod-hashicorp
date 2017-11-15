# == Class: lantern_hashicorp
#
# Installs, configures, and manages Hashicorp tools for Lantern
#

class lantern_hashicorp (
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
  # Boolean $vault_install,
  # String $vault_version,
  # String $vault_user,
  # String $vault_mode,
) {

  #run through all base installations
  class { '::lantern_hashicorp::consultemplate':
    consultemplate_version => $consultemplate_version,
    consultemplate_token   => $consultemplate_token,
    consul_acldatacenter   => $consul_acldatacenter,
  }

  class { '::lantern_hashicorp::consul':
    consul_version                 => $consul_version,
    consul_servers                 => $consul_servers,
    consul_acldatacenter           => $consul_acldatacenter,
    consul_datacenter              => $consul_datacenter,
    consul_encrypt                 => $consul_encrypt,
    consul_master_token            => $consul_master_token,
    consul_agent_token             => $consul_agent_token,
    consul_masterdatacenterservers => $consul_masterdatacenterservers,
  }

  class { '::lantern_hashicorp::nomad':
    nomad_version     => $nomad_version,
    nomad_datacenter  => $nomad_datacenter,
    nomad_servers     => $nomad_servers,
    nomad_metatags    => $nomad_metatags,
    consul_datacenter => $consul_datacenter,
  }

}
