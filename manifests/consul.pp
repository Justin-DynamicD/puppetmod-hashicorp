# == Class puppetmod-hashicorp::consul
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets up consul.
#

class puppetmod-hashicorp::consul (
  Array $consul_servers,
  String $consul_docker_image,
  String $consul_user,
  String $consul_version,
  String $consul_encrypt,
  String $consul_master_token,
  String $consul_agent_token,
  String $consul_datacenter ) {

  #Validate which ip to join
  if $::ipaddress in $consul_servers {
    $server_mode = true
    $retry_join = $consul_servers - "${::ipaddress}"
  }
  else {
    $server_mode = false
    $retry_join = $consul_servers
  }

  # Standard Install

  if $facts['os']['family'] != 'windows' {

    ensure_packages(['unzip'], {'ensure' => 'present'})

    if $facts['networking']['interfaces']['docker0'] {
      $install_method = 'docker'
    }
    else {
      $install_method = 'url'
    }

    if $server_mode {
      class { '::consul' :
        version        => $consul_version,
        install_method => $install_method,
        config_hash    => {
          'skip_leave_on_interrupt' => true, 
          'bind_addr'               => "${::ipaddress}",
          'client_addr'             => '0.0.0.0',
          'ports'                   => {
            'dns'                     => 53,
          },
          'bootstrap_expect'        => 3,
          'data_dir'                => '/opt/consul',
          'datacenter'              => $consul_datacenter,
          'log_level'               => 'INFO',
          'server'                  => $server_mode,
          'ui'                      => true,
          'retry_join'              => $retry_join,
          'encrypt'                 => $consul_encrypt,
          'encrypt_verify_incoming' => true,
          'encrypt_verify_outgoing' => true,
          'acl_datacenter'          => $consul_datacenter,
          'acl_default_policy'      => "deny",
          'acl_down_policy'         => "deny",
          'acl_master_token'        => $consul_master_token,
          'acl_agent_token'         => $consul_agent_token,
        }
      }
    }
    else {
      class { '::consul' :
        version        => $consul_version,
        install_method => 'url',
        manage_config  => false,
        manage_service => false,
      } 
    }

  } # temporary windows bypass
  else {
    package { 'consul' :
      ensure   => $consul_version,
      provider => 'chocolatey',
    }

    file { 'C:\programdata\consul\config\config.json' :
      ensure  => 'present',
      content => "{\"acl_datacenter\":\"${datacenter}\",\"acl_token\":\"${consul_agent_token}\",\"bind_addr\":\"${::ipaddress}\",\"datacenter\":\"${datacenter}\",\"encrypt\":\"${consul_encrypt}\",\"encrypt_verify_incoming\":true,\"encrypt_verify_outgoing\":true,\"leave_on_terminate\":true,\"log_level\":\"INFO\",\"retry_join\":[\"10.10.30.10\",\"10.10.31.10\",\"10.10.32.10\"],\"server\":false}",
      require => Package['consul'],
      notify  => Exec['restart-consul'],
    }

    exec { 'restart-consul' :
      refreshonly => true,
      provider    => powershell,
      command     => "restart-service consul",
    }

  }

}
