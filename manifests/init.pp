# === Class: nova_hyper_v
#
# This class is used to specify configuration parameters that are common
# across all nova services for Hyper-V platform
#
# === Parameters:
#
# [*database_idle_timeout*]
#   (optional) Timeout before idle db connections are reaped.
#   Defaults to 3600
#
# [*rpc_backend*]
#   (optional) The rpc backend implementation to use, can be:
#     nova.openstack.common.rpc.impl_kombu (for rabbitmq)
#     nova.openstack.common.rpc.impl_qpid  (for qpid)
#   Defaults to 'nova.openstack.common.rpc.impl_kombu'
#
# [*image_service*]
#   (optional) Service used to search for and retrieve images.
#   Defaults to 'nova.image.local.LocalImageService'
#
# [*glance_api_servers*]
#   (optional) List of addresses for api servers.
#   Defaults to 'localhost:9292'
#
# [*memcached_servers*]
#   (optional) Use memcached instead of in-process cache. Supply a list of memcached server IP's:Memcached Port.
#   Defaults to false
#
# [*rabbit_host*]
#   (optional) Location of rabbitmq installation.
#   Defaults to 'localhost'
#
# [*rabbit_hosts*]
#   (optional) List of clustered rabbit servers.
#   Defaults to false
#
# [*rabbit_port*]
#   (optional) Port for rabbitmq instance.
#   Defaults to '5672'
#
# [*rabbit_password*]
#   (optional) Password used to connect to rabbitmq.
#   Defaults to 'guest'
#
# [*rabbit_userid*]
#   (optional) User used to connect to rabbitmq.
#   Defaults to 'guest'
#
# [*rabbit_virtual_host*]
#   (optional) The RabbitMQ virtual host.
#   Defaults to '/'
#
# [*qpid_hostname*]
#   (optional) Location of qpid server
#   Defaults to 'localhost'
#
# [*qpid_port*]
#   (optional) Port for qpid server
#   Defaults to '5672'
#
# [*qpid_username*]
#   (optional) Username to use when connecting to qpid
#   Defaults to 'guest'
#
# [*qpid_password*]
#   (optional) Password to use when connecting to qpid
#   Defaults to 'guest'
#
# [*qpid_heartbeat*]
#   (optional) Seconds between connection keepalive heartbeats
#   Defaults to 60
#
# [*qpid_protocol*]
#   (optional) Transport to use, either 'tcp' or 'ssl''
#   Defaults to 'tcp'
#
# [*qpid_sasl_mechanisms*]
#   (optional) Enable one or more SASL mechanisms
#   Defaults to false
#
# [*qpid_tcp_nodelay*]
#   (optional) Disable Nagle algorithm
#   Defaults to true
#
# [*service_down_time*]
#   (optional) Maximum time since last check-in for up service.
#   Defaults to 60
#
# [*logdir*]
#   (optional) Directory where logs should be stored.
#   Defaults to '/var/log/nova'
#
# [*state_path*]
#   (optional) Directory for storing state.
#   Defaults to '/var/lib/nova'
#
# [*lock_path*]
#   (optional) Directory for lock files.
#   On RHEL will be '/var/lib/nova/tmp' and on Debian '/var/lock/nova'
#   Defaults to $::nova::params::lock_path
#
# [*verbose*]
#   (optional) Set log output to verbose output.
#   Defaults to false
#
# [*periodic_interval*]
#   (optional) Seconds between running periodic tasks.
#   Defaults to '60'
#
# [*report_interval*]
#   (optional) Interval at which nodes report to data store.
#    Defaults to '10'
#
# [*monitoring_notifications*]
#   (optional) Whether or not to send system usage data notifications out on the message queue. Only valid for stable/essex.
#   Defaults to false
#
# [*use_syslog*]
#   (optional) Use syslog for logging
#   Defaults to false
#
# [*log_facility*]
#   (optional) Syslog facility to receive log lines.
#   Defaults to 'LOG_USER'
#
class nova_hyper_v (
  # this is how to query all resources from our clutser
  $rpc_backend              = 'nova.openstack.common.rpc.impl_kombu',
  $image_service            = 'nova.image.glance.GlanceImageService',
  # these glance params should be optional
  # this should probably just be configured as a glance client
  $glance_api_servers       = 'localhost:9292',
  $memcached_servers        = false,
  $rabbit_config_cluster    = false,
  $rabbit_host              = 'localhost',
  $rabbit_hosts             = false,
  $rabbit_password          = 'guest',
  $rabbit_port              = '5672',
  $rabbit_userid            = 'guest',
  $rabbit_virtual_host      = '/',
  $qpid_hostname            = 'localhost',
  $qpid_port                = '5672',
  $qpid_username            = 'guest',
  $qpid_password            = 'guest',
  $qpid_sasl_mechanisms     = false,
  $qpid_heartbeat           = 60,
  $qpid_protocol            = 'tcp',
  $qpid_tcp_nodelay         = true,
  $auth_strategy            = 'keystone',
  $service_down_time        = 60,
  $logdir                   = $::nova_hyper_v::params::logdir,
  $state_path               = $::nova_hyper_v::params::state_path,
  $lock_path                = $::nova_hyper_v::params::lock_path,
  $verbose                  = false,
  $debug                    = false,
  $periodic_interval        = '60',
  $report_interval          = '10',
  $monitoring_notifications = false,
  $use_syslog               = false,
  $log_facility             = 'LOG_USER',
  $nova_version             = '2013.1.4',
  $nova_repository          = 'git+https://github.com/openstack/nova',
  $nova_source              = false,  
) inherits nova_hyper_v::params {

  # all hyperv_nova_config resources should be applied
  # before the file resource for nova.conf is managed
  # and before the post config resource
  Class["nova_hyper_v::common"] -> Hyperv_nova_config<| |> -> File[$::nova_hyper_v::params::confdir]
  Hyperv_nova_config<| |> ~> Exec['post-nova_config']

  class { 'nova_hyper_v::dependencies':
    version => $nova_version,
  }

  class { 'nova_hyper_v::utilities': }

  # this anchor is used to simplify the graph between nova components by
  # allowing a resource to serve as a point where the configuration of nova begins
  anchor { 'nova-start': }

  # nova-common: folders, etc...
  class { "nova_hyper_v::common":
    require => Anchor['nova-start']
  }
  # end nova-common

  if $nova_source {
    exec{ "install-nova-from-egg":
      command  => "& easy_install.exe '${nova_source}'",
      unless   => "\$output = pip freeze; exit !(\$output.ToLower().Contains(\"nova==${nova_version}\".ToLower()))",
      provider => powershell,
      notify   => Exec['post-nova_config'],
      require  => [Class['nova_hyper_v::utilities'], Class['nova_hyper_v::dependencies']],
    }
  } else {
    windows_python::package::pip { "nova":
      version => $nova_version,
      source  => $nova_repository,
      notify  => Exec['post-nova_config'],
      require => [Class['nova_hyper_v::utilities'], Class['nova_hyper_v::dependencies']],
    }
  }

  #file { $logdir:
  #  ensure => directory,
  #  mode   => '0750',
  #}

  file { 'C:/OpenStack/etc/nova/logging.conf':
    ensure  => file,
    mode    => 0770,
    source  => "puppet:///modules/nova_hyper_v/logging.conf",
    notify  => Exec['post-nova_config'],
    require => Class['nova_hyper_v::common'],
  }

  file { 'C:/OpenStack/etc/nova/policy.json':
    ensure  => file,
    mode    => 0770,
    source  => "puppet:///modules/nova_hyper_v/policy.json",
    notify  => Exec['post-nova_config'],
    require => Class['nova_hyper_v::common'],
  }

  hyperv_nova_config {'DEFAULT/log_config':  value => 'C:\OpenStack\etc\nova\logging.conf';}
  hyperv_nova_config {'DEFAULT/policy_file': value => 'C:\OpenStack\etc\nova\policy.json';}

  file { $::nova_hyper_v::params::confdir :
    mode => '0650',
  }

  hyperv_nova_config { 'DEFAULT/image_service': value => $image_service }

  if $image_service == 'nova.image.glance.GlanceImageService' {
    if $glance_api_servers {
      hyperv_nova_config { 'DEFAULT/glance_api_servers': value => $glance_api_servers }
    }
  }

  hyperv_nova_config { 'DEFAULT/auth_strategy': value => $auth_strategy }

  if $memcached_servers {
    hyperv_nova_config { 'DEFAULT/memcached_servers': value => join($memcached_servers, ',') }
  } else {
    hyperv_nova_config { 'DEFAULT/memcached_servers': ensure => absent }
  }

  if $rpc_backend == 'nova.openstack.common.rpc.impl_kombu' {
    # I may want to support exporting and collecting these
    hyperv_nova_config {
      'DEFAULT/rabbit_password':     value =>  $rabbit_password, secret => true;
      'DEFAULT/rabbit_userid':       value => $rabbit_userid;
      'DEFAULT/rabbit_virtual_host': value => $rabbit_virtual_host;
    }


    if ($rabbit_config_cluster) == true {
      hyperv_nova_config { 'DEFAULT/rabbit_ha_queues': value => 'true' }
    } else {
      hyperv_nova_config { 'DEFAULT/rabbit_ha_queues': value => 'false' }
    }

    if $rabbit_config_cluster == true {
      hyperv_nova_config { 'DEFAULT/rabbit_hosts': value => inline_template("<%= rabbit_hosts.map {|x| x}.join ',' %>") }
    } else {
      hyperv_nova_config { 'DEFAULT/rabbit_host':  value => $rabbit_host }
      hyperv_nova_config { 'DEFAULT/rabbit_port':  value => $rabbit_port }
      hyperv_nova_config { 'DEFAULT/rabbit_hosts': value => "${rabbit_host}:${rabbit_port}" }
    }
  }

  if $rpc_backend == 'nova.openstack.common.rpc.impl_qpid' {
    hyperv_nova_config {
      'DEFAULT/qpid_hostname':    value => $qpid_hostname;
      'DEFAULT/qpid_port':        value => $qpid_port;
      'DEFAULT/qpid_username':    value => $qpid_username;
      'DEFAULT/qpid_password':    value => $qpid_password;
      'DEFAULT/qpid_heartbeat':   value => $qpid_heartbeat;
      'DEFAULT/qpid_protocol':    value => $qpid_protocol;
      'DEFAULT/qpid_tcp_nodelay': value => $qpid_tcp_nodelay;
    }
    if is_array($qpid_sasl_mechanisms) {
      hyperv_nova_config {
        'DEFAULT/qpid_sasl_mechanisms': value => join($qpid_sasl_mechanisms, ' ');
      }
    }
    elsif $qpid_sasl_mechanisms {
      hyperv_nova_config {
        'DEFAULT/qpid_sasl_mechanisms': value => $qpid_sasl_mechanisms;
      }
    }
    else {
      hyperv_nova_config {
        'DEFAULT/qpid_sasl_mechanisms': ensure => absent;
      }
    }
  }

  hyperv_nova_config {
    'DEFAULT/verbose':           value => $verbose;
    'DEFAULT/debug':             value => $debug;
    'DEFAULT/logdir':            value => $logdir;
    'DEFAULT/rpc_backend':       value => $rpc_backend;
    # Following may need to be broken out to different nova services
    'DEFAULT/state_path':        value => $state_path;
    'DEFAULT/lock_path':         value => $lock_path;
    'DEFAULT/service_down_time': value => $service_down_time;
  }

  if $monitoring_notifications {
    hyperv_nova_config {
      'DEFAULT/notification_driver': value => 'nova.openstack.common.notifier.rpc_notifier'
    }
  }

  # Syslog configuration
  if $use_syslog {
    hyperv_nova_config {
      'DEFAULT/use_syslog':          value => true;
      'DEFAULT/syslog_log_facility': value => $log_facility;
    }
  } else {
    hyperv_nova_config {
      'DEFAULT/use_syslog': value => false;
    }
  }

  exec { 'post-nova_config':
    command     => 'cmd.exe /c echo "Nova config has changed"',
    refreshonly => true,
    path        => $::path,
  }
}
