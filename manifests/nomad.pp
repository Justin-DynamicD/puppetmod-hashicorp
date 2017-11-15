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
    unless  => "nomad version | grep ${nomad_version}",
    require => Exec['pull_repo'],
  }

}
