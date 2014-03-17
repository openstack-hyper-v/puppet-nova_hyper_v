# == Class nova_hyper_v::utilities
#
# Extra packages used by nova tools
class nova_hyper_v::utilities {
  include nova_hyper_v::params

  if $::osfamily == 'windows' {
    class {'windows_git': }
  }
}
