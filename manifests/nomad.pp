# == Class puppetmod-hashicorp::nomad
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets up consul.
#

class puppetmod-hashicorp::nomad (
  String $consultemplate_executable,
  String $consultemplate_version,
  String $consultemplate_baseurl,
  String $consultemplate_lchecksum,
  String $consultemplate_wchecksum,
  String $consultemplate_type,

  String $datacenter,

  ) {

}
