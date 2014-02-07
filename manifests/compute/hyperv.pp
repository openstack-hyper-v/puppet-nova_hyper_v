class nova_hyper_v::compute::hyperv (
  # Live Migration
  $live_migration            = false,
  $live_migration_type       = 'Kerberos',
  $live_migration_networks   = undef,
  # Virtual Switch
  $virtual_switch_name       = 'br100',
  $virtual_switch_address    = $::ipaddress,
  $virtual_switch_os_managed = true,
  # General
  $instances_path            = 'C:\OpenStack\Instances',
  $qemu_img_cmd              = 'qemu-img.exe',
  $mkisofs_md                = 'mkisofs.exe',
){
  class { 'hyper_v': }

  class { 'hyper_v::live_migration':
    enable              => $live_migration,
    authentication_type => $live_migration_type,
    allowed_networks    => $live_migration_networks,
    require             => Class['hyper_v'],
  }

  virtual_switch { $virtual_switch_name:
    notes             => 'OpenStack Compute Virtual Switch',
    interface_address => $virtual_switch_address,
    type              => 'External',
    os_managed        => $virtual_switch_os_managed,
    require           => Class['hyper_v'],
  }

  hyperv_nova_config {
    'DEFAULT/compute_driver':     value => 'nova.virt.hyperv.driver.HyperVDriver';
    'HYPERV/vswitch_name':        value => $virtual_switch_name;
    'DEFAULT/instances_path':     value => $instances_path;
    'HYPERV/limit_cpu_features':  value => 'false';
    'DEFAULT/mkisofs_cmd':        value => $mkisofs_md;
    'HYPERV/qemu_img_cmd':        value => $qemu_img_cmd;
    'DEFAULT/use_cow_images':     value => 'true';
  }
}
