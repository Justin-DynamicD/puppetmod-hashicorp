# == Class: puppetmod-hashicorp
#
# Installs, configures, and manages Hashicorp tools for Lantern
#

class puppetmod-hashicorp (
  String $consul_version = $::puppetmod-hashicorp::params::consul_version,
  Array $consul_servers = $::puppetmod-hashicorp::params::consul_servers,
  String $consul_acldatacenter = $::puppetmod-hashicorp::params::consul_acldatacenter,
  String $consul_datacenter = $::puppetmod-hashicorp::params::consul_datacenter,
  String $consul_docker_image = $::puppetmod-hashicorp::params::consul_docker_image,
  String $consul_encrypt = $::puppetmod-hashicorp::params::consul_encrypt,
  String $consul_master_token = $::puppetmod-hashicorp::params::consul_master_token,
  String $consul_agent_token = $::puppetmod-hashicorp::params::consul_agent_token,
  String $consultemplate_version = $::puppetmod-hashicorp::params::consultemplate_version,
  String $consultemplate_executable = $::puppetmod-hashicorp::params::consultemplate_executable,
  String $consultemplate_baseurl = $::puppetmod-hashicorp::params::consultemplate_baseurl,
  String $consultemplate_lchecksum = $::puppetmod-hashicorp::params::consultemplate_lchecksum,
  String $consultemplate_wchecksum = $::puppetmod-hashicorp::params::consultemplate_wchecksum,
  String $consultemplate_type = $::puppetmod-hashicorp::params::consultemplate_type,
  Boolean $nomad_install = $::puppetmod-hashicorp::params::nomad_install,
  String $nomad_version = $::puppetmod-hashicorp::params::nomad_version,
  String $nomad_user = $::puppetmod-hashicorp::params::nomad_user,
  Array $nomad_servers = $::puppetmod-hashicorp::params::nomad_servers,
  String $nomad_datacenter = $::puppetmod-hashicorp::params::nomad_datacenter,
  Boolean $vault_install = $::puppetmod-hashicorp::params::vault_install,
  String $vault_version = $::puppetmod-hashicorp::params::vault_version,
  String $vault_user = $::puppetmod-hashicorp::params::vault_user,
  String $vault_mode = $::puppetmod-hashicorp::params::vault_mode,
) inherits puppetmod-hashicorp::params {

  #run through all base installations
  class { '::puppetmod-hashicorp::consultemplate':
    consultemplate_version    => $consultemplate_version,
    consultemplate_executable => $consultemplate_executable,
    consultemplate_baseurl    => $consultemplate_baseurl,
    consultemplate_lchecksum  => $consultemplate_lchecksum,
    consultemplate_wchecksum  => $consultemplate_wchecksum,
    consultemplate_type       => $consultemplate_type,
  }

  class { '::puppetmod-hashicorp::consul':
    consul_version      => $consul_version,
    consul_user         => $consul_user,
    consul_servers      => $consul_servers,
    consul_datacenter   => $consul_datacenter,
    consul_docker_image => $consul_docker_image,
    consul_encrypt      => $consul_encrypt,
    consul_master_token => $consul_master_token,
    consul_agent_token  => $consul_agent_token,
  }

}
