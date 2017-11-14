# == Class puppetmod-hashicorp::consul
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets up consul.
#

class lantern_hashicorp::consul (
  Array $consul_servers,
  String $consul_version,
  String $consul_encrypt,
  String $consul_master_token,
  String $consul_agent_token,
  Array $consul_masterdatacenterservers,
  String $consul_acldatacenter,
  String $consul_datacenter ) {

  #Validate server vs client
  if $::ipaddress in $consul_servers {
    $template = 'consulserver_template'
    $retry_join = $consul_servers - $::ipaddress
    $bootstrap_count = count ($consul_servers)
  }
  else {
    $template = 'consulclient_template'
    $retry_join = $consul_servers
  }

  #Adjust server config by datacenter
  if $consul_acldatacenter == $consul_datacenter {
    $wan_join = []
  }
  else {
    $wan_join = $consul_masterdatacenterservers
  }

  # Linux Install
  if $facts['os']['family'] != 'windows' {

    # Install components
    ensure_packages(['unzip', 'dnsmasq'], {'ensure' => 'present'})
    -> class { '::consul' :
      version        => $consul_version,
      install_method => 'url',
      manage_config  => false,
      manage_service => false,
    }

    # Set templates
    file { '/etc/consul/config.json' :
      ensure => 'file',
      owner  => 'consul',
      group  => 'consul',
    }
    -> file { '/etc/consul-template/templates/consul.ctmpl' :
      ensure  =>  'file',
      content =>  template("lantern_hashicorp/${template}.erb"),
      notify  => Service['consul-template'],
    }
    -> file { '/etc/consul-template/config/consul.cfg' :
      ensure  =>  'file',
      content =>  template('lantern_hashicorp/consul_config.erb'),
      notify  => Service['consul-template'],
    }

    # enable dnsmasq redirect
    file { '/etc/dnsmasq.d/10-consul' :
      ensure  =>  'file',
      content =>  'server=/consul/127.0.0.1#8600',
    }

  } # temporary windows bypass
  else {
    package { 'consul' :
      ensure   => $consul_version,
      provider => 'chocolatey',
    }

    file { 'C:\programdata\consul\config\config.json' :
      ensure  => 'present',
      content => "{\"acl_datacenter\":\"${consul_acldatacenter}\",\"acl_token\":\"${consul_agent_token}\",\"bind_addr\":\"${::ipaddress}\",\"datacenter\":\"${consul_datacenter}\",\"encrypt\":\"${consul_encrypt}\",\"encrypt_verify_incoming\":true,\"encrypt_verify_outgoing\":true,\"leave_on_terminate\":true,\"log_level\":\"INFO\",\"retry_join\":${retry_join},\"server\":false}",
      require => Package['consul'],
      notify  => Exec['restart-consul'],
    }

    exec { 'restart-consul' :
      refreshonly => true,
      provider    => powershell,
      command     => 'restart-service consul',
    }

  }

}
