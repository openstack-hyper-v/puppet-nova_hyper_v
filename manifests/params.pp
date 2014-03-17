# == Class: hyper_v_nova::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
class nova_hyper_v::params {

  case $::osfamily {
    #'RedHat': {
    #}
    #'Debian': {
    #}
    'windows': {
      # general
      $confdir              = 'C:/OpenStack/etc/nova/nova.conf'
      $logdir               = 'C:/OpenStack/log'
      $state_path           = 'C:/OpenStack/lib'
      # package names
      $compute_package_name = undef
      # service names
      $compute_service_name = 'nova-compute'
      # Python
      $python_from_source   = false 
      $python_installer     = undef
      $python_installdir    = 'C:\Python27'
      $easyinstall_script   = undef
      $pip_script           = undef
      # Python packages
      $m2crypto             = { version   => '0.21.1', 
                                url       => 'http://chandlerproject.org/pub/Projects/MeTooCrypto/M2Crypto-0.21.1.win32-py2.7.exe',
                                installer => undef }
      $mysql                = { version   => '1.2.3',
                                url       => 'http://www.codegood.com/download/10/',
                                installer => undef }
      $pycrypto             = { version   => '2.6',
                                url       => 'http://www.voidspace.org.uk/downloads/pycrypto26/pycrypto-2.6.win32-py2.7.exe',
                                installer => undef }
      $pywin32              = { version   => '217',
                                url       => 'http://sourceforge.net/projects/pywin32/files/pywin32/Build%20217/pywin32-217.win32-py2.7.exe/download',
                                installer => undef }
      $greenlet             = { version   => '0.4.0',
                                url       => 'https://pypi.python.org/packages/2.7/g/greenlet/greenlet-0.4.0.win32-py2.7.exe#md5=910896116b1e4fd527b8afaadc7132f3',
                                installer => undef }
      $lxml                 = { version   => '2.3',
                                url       => 'https://pypi.python.org/packages/2.7/l/lxml/lxml-2.3.win32-py2.7.exe#md5=9c02aae672870701377750121f5a6f84',
                                installer => undef }
      $numpy                = { version   => '1.7.1',
                                url       => 'https://pypi.python.org/packages/2.7/n/numpy/numpy-1.7.1.win32-py2.7.exe',
                                installer => undef }
      $psutil               = { version   => '1.2.1',
                                url       => 'https://pypi.python.org/packages/2.7/p/psutil/psutil-1.2.1.win32-py2.7.exe#md5=c4264532a64414cf3aa0d8b17d17e015',
                                installer => undef }
      $pyopenssl            = { version   => '0.13.1',
                                url       => 'https://pypi.python.org/packages/2.7/p/pyOpenSSL/pyOpenSSL-0.13.1.win32-py2.7.exe',
                                installer => undef } 
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }
}
