# == Class: nova::compute
#
# Installs the nova-compute service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the nova-compute service
#   Defaults to false
#
# [*ensure_package*]
#   (optional) The state for the nova-compute package
#   Defaults to 'present'
#
# [*vnc_enabled*]
#   (optional) Whether to use a VNC proxy
#   Defaults to true
#
# [*vncserver_proxyclient_address*]
#   (optional) The IP address of the server running the VNC proxy client
#   Defaults to '127.0.0.1'
#
# [*vncproxy_host*]
#   (optional) The host of the VNC proxy server
#   Defaults to false
#
# [*vncproxy_protocol*]
#   (optional) The protocol to communicate with the VNC proxy server
#   Defaults to 'http'
#
# [*vncproxy_port*]
#   (optional) The port to communicate with the VNC proxy server
#   Defaults to '6080'
#
# [*vncproxy_path*]
#   (optional) The path at the end of the uri for communication with the VNC proxy server
#   Defaults to './vnc_auto.html'
#
# [*force_config_drive*]
#   (optional) Whether to force the config drive to be attached to all VMs
#   Defaults to false
#
# [*virtio_nic*]
#   (optional) Whether to use virtio for the nic driver of VMs
#   Defaults to false
#
# [*neutron_enabled*]
#   (optional) Whether to use Neutron for networking of VMs
#   Defaults to true
#
# [*network_device_mtu*]
#   (optional) The MTU size for the interfaces managed by nova
#   Defaults to undef
#
class nova_hyper_v::compute (
  $enabled                       = false,
  $ensure_package                = 'present',
  $force_config_drive            = false,
  $hyperv_service_user           = 'LocalSystem',
  $hyperv_service_pass           = '',
) {

  include nova_hyper_v::params

  nova_hyper_v::generic_service { 'compute':
    enabled        => $enabled,
    package_name   => $::nova_hyper_v::params::compute_package_name,
    service_name   => $::nova_hyper_v::params::compute_service_name,
    ensure_package => $ensure_package,
    hyperv_service_user   => $hyperv_service_user,
    hyperv_service_pass   => $hyperv_service_pass,
  }

  if $force_config_drive {
    hyperv_nova_config { 'DEFAULT/force_config_drive': value => true }
  } else {
    hyperv_nova_config { 'DEFAULT/force_config_drive': ensure => absent }
  }
}
