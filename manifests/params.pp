# == Class puppetmod-hashicorp::params
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets default variables.
#

class puppetmod-lantern_hashicorp::params {
  # Define all default parameters
  $consul_version            = '1.0.0'
  $consul_servers            =  ['10.10.30.10', '10.10.31.10', '10.10.32.10']
  $consul_acldatacenter      = 'lv-ops'
  $consul_datacenter         = 'lv-ops'
  $consul_docker_image       = 'consul'
  $consul_encrypt            = 'Ok02uszmHd6ijEkRzm4MEg=='
  $consul_master_token       = '9c97a554-1b73-4cd7-9547-3c2c26b3a45d'
  $consul_agent_token        = 'bc32b60c-8374-5e57-70cc-e44311bb9131'

  $consultemplate_version    = '0.19.3'
  $consultemplate_user       = 'root'
  $consultemplate_executable = 'consul-template'
  $consultemplate_baseurl    = 'https://releases.hashicorp.com/consul-template'
  $consultemplate_lchecksum  = '47b3f134144b3f2c6c1d4c498124af3c4f1a4767986d71edfda694f822eb7680'
  $consultemplate_wchecksum  = 'b1c515552641d2de7ab8ba022031ddad557f06bf4ca87856b546812c340edebd'
  $consultemplate_type       = 'sha256'

  $nomad_install             = true
  $nomad_version             = '0.7.0'
  $nomad_user                = 'nomad'
  $nomad_servers             = ['10.10.30.10', '10.10.31.10', '10.10.32.10']
  $nomad_datacenter          = 'lv-ops'

  $vault_install             = false
  $vault_version             = 'latest'
  $vault_user                = 'vault'
  $vault_mode                = 'docker'

}
