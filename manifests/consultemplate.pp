# == Class puppetmod-hashicorp::consultemplate
#
# This class is meant to be called from puppetmod-hashicorp.
# It sets up consul.
#

class puppetmod-hashicorp::consultemplate (
  String $consultemplate_executable,
  String $consultemplate_version,
  String $consultemplate_baseurl,
  String $consultemplate_lchecksum,
  String $consultemplate_wchecksum,
  String $consultemplate_type,
  String $consul_datacenter,
  ) {

  #Install Consul-Template
  class { 'consul_template':
    service_enable   => true,
    vault_enabled    => true,
    vault_address    => 'http://active.lv-vault.service.consul:8200',
    vault_token      => 'b83a3dfd-361d-d4e9-a9b5-bdbd532e35ae',
    vault_ssl        => false,
    vault_ssl_verify => false,
    consul_wait      => '5s:30s',
}

  # create default consul configs and template
  $consul_config = @(TEMPLATEEND)
template {
  source = "/etc/consul-template/templates/consul.ctmpl"
  destination = "/etc/consul/config.json"
  command = "service consul restart"
}
TEMPLATEEND

  $consul_template = @(TEMPLATEEND)
{
  "leave_on_terminate":true,
  "bind_addr":"<%= @ipaddress %>",
  "data_dir":"/opt/consul",
  "datacenter":"<%= @consul_datacenter %>",
  "log_level":"INFO",
  "server":false,
  "retry_join":["10.10.30.10","10.10.31.10","10.10.32.10"],
  "encrypt":"{{ with secret "secret/consul/encrypt_key" }}{{ .Data.value }}{{ end }}",
  "encrypt_verify_incoming":true,
  "encrypt_verify_outgoing":true,
  "acl_datacenter":"<%= @consul_datacenter %>",
  "acl_token":"{{ with secret "secret/consul/agent_token" }}{{ .Data.value }}{{ end }}"
}
TEMPLATEEND

  #place files
  file { '/etc/consul-template/config/consul.cfg' :
    ensure => 'file',
    content => inline_template($consul_config),
    require => File['/etc/consul-template/config'],
    notify  => Service['consul-template'],
  }

  file { '/etc/consul-template/templates/consul.ctmpl' :
    ensure => 'file',
    content => inline_template($consul_template),
    require => File['/etc/consul-template/templates'],
    notify  => Service['consul-template'],
  }

}
