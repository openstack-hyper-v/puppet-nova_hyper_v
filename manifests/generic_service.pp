# == Define: nova::generic_service
#
# This defined type implements basic nova services.
# It is introduced to attempt to consolidate
# common code.
#
# It also allows users to specify ad-hoc services
# as needed
#
# This define creates a service resource with title nova-${name} and
# conditionally creates a package resource with title nova-${name}
#
define nova_hyper_v::generic_service(
  $package_name,
  $service_name,
  $enabled        = false,
  $ensure_package = 'present',
  $hyperv_service_user           = 'LocalSystem',
  $hyperv_service_pass           = '',
) {

  include nova_hyper_v::params

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  $nova_title = "nova-${name}"
  # ensure that the service is only started after
  # all nova config entries have been set
  Exec['post-nova_config'] ~> Service<| title == $nova_title |>
  # ensure that the service has only been started
  # after the initial db sync
  Exec<| title == 'nova-db-sync' |> ~> Service<| title == $nova_title |>


  # I need to mark that ths package should be
  # installed before nova_config
  if ($package_name) {
    package { $nova_title:
      ensure => $ensure_package,
      name   => $package_name,
      notify => Service[$nova_title],
      before => Service[$nova_title],
    }
  }

  if($::osfamily == 'windows'){
    Windows_python::Package::Pip['nova'] -> Service[$nova_title]

    file { "C:/OpenStack/Services/Nova${name}Service.py":
      ensure             => file,
      #source_permissions => ignore,
      source             => "puppet:///modules/nova_hyper_v/Nova${name}Service.py",
      require            => Class['nova_hyper_v::common']
    }

    windows_python::windows_service { $nova_title:
      description => "${nova_title} service for Hyper-V",
      arguments   => '--config-file=C:\OpenStack\etc\nova\nova.conf',
      script      => "C:\\OpenStack\\services\\Nova${name}Service.Nova${name}Service",
      user        => $hyperv_service_user,
      password    => $hyperv_service_pass,
      require     => File["C:/OpenStack/Services/Nova${name}Service.py"],
      before      => Service[$nova_title],
    }
  }

  if ($::osfamily != 'windows'){
    Package['nova-common'] -> Service[$nova_title]
  } else {
    Class['nova_hyper_v::common'] -> Service[$nova_title]
  }

  if ($service_name) {
    service { $nova_title:
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $enabled,
      hasstatus => true,
    }
  }

}
