# == Class: nova_hyper_v::network
#
# Manages nova-network. Note that
# Nova-network is not receiving upstream patches any more
# and Neutron should be used in its place
#
# === Parameters:
#
# [*private_interface*]
#   (optional) Interface used by private network.
#   Defaults to undef
#
# [*fixed_range*]
#   (optional) Fixed private network range.
#   Defaults to '10.0.0.0/8'
#
# [*public_interface*]
#   (optional) Interface used to connect vms to public network.
#   Defaults to undef
#
# [*num_networks*]
#   (optional) Number of networks that fixed range network should be
#   split into.
#   Defaults to 1
#
# [*floating_range*]
#   (optional) Range of floating ip addresses to create.
#   Defaults to false
#
# [*enabled*]
#   (optional) Whether the network service should be enabled.
#   Defaults to false
#
# [*network_manager*]
#   (optional) The type of network manager to use.
#   Defaults to 'nova.network.manager.FlatDHCPManager'
#
# [*config_overrides*]
#   (optional) Additional parameters to pass to the network manager class
#   Defaults to {}
#
# [*create_networks*]
#   (optional) Whether actual nova networks should be created using
#   the fixed and floating ranges provided.
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state of the nova network package
#   Defaults to 'present'
#
# [*install_service*]
#   (optional) Whether to install and enable the service
#   Defaults to true
#
class nova_hyper_v::network(
  $network_manager   = 'nova.network.manager.FlatDHCPManager',
) {
  hyperv_nova_config {
    'DEFAULT/network_manager':                        value => $network_manager;
  }
}
