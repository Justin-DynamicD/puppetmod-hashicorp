# == Class lantern_hashicorp::nomad
#
# This class is meant to be called from lantern_hashicorp.
# It sets up consul.
#

class lantern_hashicorp::nomad (
  String $nomad_version,
  String $nomad_datacenter,
  Array $nomad_servers,
  String $nomad_metatags,
  String $consul_datacenter,
  String $nomad_gitver = 'v0.0.2',
  String $nomad_gitsource = 'https://github.com/hashicorp/terraform-aws-nomad.git',
) {

  #Validate server vs client
  if $::ipaddress in $nomad_servers {
    $template = 'nomadserver_template'
    $bootstrap_count = count ($nomad_servers)
  }
  else {
    $template = 'nomadclient_template'
  }

  # grab installer from registry.terraform and install
  file { '/apps' :
    ensure  =>  'directory',
  }
  file { '/apps/nomad_install' :
    ensure  =>  'directory',
    require => File['/apps'],
  }
  exec { 'pull_repo' :
    command => "git clone --branch ${nomad_gitver} ${nomad_gitsource} /apps/nomad_install",
    path    => '/usr/bin:/usr/sbin:/bin',
    creates => '/apps/nomad_install/README.md',
    require => File['/apps/nomad_install'],
  }
  exec { 'install_nomad' :
    command => "/apps/nomad_install/modules/install-nomad/install-nomad --version ${nomad_version}",
    path    => '/usr/bin:/usr/sbin:/bin',
    unless  => "/usr/local/bin/nomad version | grep ${nomad_version}",
    require => Exec['pull_repo'],
  }
  user { 'nomad' :
    ensure => present,
    groups => ["docker","sudo"],
  }
  sudo::conf { 'nomad':
    priority => 10,
    content  => "nomad   ALL=(ALL:ALL) ALL",
  }

  # Set service
  file { '/etc/systemd/system/nomad.service' :
    ensure  => 'file',
    content => file('lantern_hashicorp/nomad.service'),
    notify  => Exec['reload systemd']
  }
  exec { 'reload systemd' :
    command     => 'systemctl daemon-reload',
    path        => '/usr/bin:/usr/sbin:/bin',
    refreshonly => true,
  }

  # Set templates
  file { '/opt/nomad/config/config.hcl' :
      ensure => 'file',
      owner  => 'nomad',
      group  => 'nomad',
    }
    -> file { '/etc/consul-template/templates/nomad.ctmpl' :
      ensure  => 'file',
      content => template("lantern_hashicorp/${template}.erb"),
      notify  => Service['consul-template'],
    }
    -> file { '/etc/consul-template/config/nomad.cfg' :
      ensure  =>  'file',
      content =>  template('lantern_hashicorp/nomad_config.erb'),
      notify  => Service['consul-template'],
    }

}
