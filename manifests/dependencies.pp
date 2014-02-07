class nova_hyper_v::dependencies (
  $python_from_source = $::nova_hyper_v::params::build_from_source,
  $pypi_proxy         = $::nova_hyper_v::params::python_pip_proxy,
  $version,
) inherits nova_hyper_v::params {

  if $python_from_source {
    class { 'mingw':
      before => Class['windows_python'],
    }
  }

  Class['windows_python'] -> Windows_python::Package::Msi<| |> -> Windows_python::Package::Exe<| |> -> Windows_python::Package::Pip<| tag == 'pip-nova-dependencies' |> 
   
  class { 'windows_python': 
    python_source      => $python_installer,
    python_installdir  => $python_installdir,
    easyinstall_source => $easyinstall_script,
    pip_source         => $pip_script,
  }

  $version_parts = split($version, '[.-]')

  windows_python::package::exe { 'M2Crypto':
    url        => $m2crypto[url],
    installer  => $m2crypto[installer],
    version    => $m2crypto[version],
  }

  windows_python::package::exe { 'MySQL-python':
    url        => $mysql[url],
    installer  => $mysql[installer],
    version    => $mysql[version],
  }

  windows_python::package::exe { 'pycrypto':
    url        => $pycrypto[url],
    installer  => $pycrypto[installer],
    version    => $pycrypto[version],
  }

  windows_python::package::exe { 'pywin32':
    url        => $pywin32[url],
    installer  => $pywin32[installer],
    version    => $pywin32[version],
  }

  exec { 'pywin32-postinstall-script':
    command     => "${python_installdir}/python.exe ${python_installdir}/Scripts/pywin32_postinstall.py -install",
    refreshonly => true,
    subscribe   => windows_python::package::exe['pywin32'],
  }

  windows_python::package::exe { 'psutil':
    url        => $psutil[url],
    installer  => $psutil[installer],
    version    => $psutil[version],
  }

  windows_python::package::exe { 'greenlet':
    url        => $greenlet[url],
    installer  => $greenlet[installer],
    version    => $greenlet[version],
  }

  windows_python::package::exe { 'lxml':
    url        => $lxml[url],
    installer  => $lxml[installer],
    version    => $lxml[version],
  }

  windows_python::package::exe { 'numpy': 
    url        => $numpy[url],
    installer  => $numpy[installer],
    version    => $numpy[version],
  }

  windows_python::package::exe{ 'pyopenssl':
    url        => $pyopenssl[url],
    installer  => $pyopenssl[source],
    version    => $pyopenssl[version],
  }

  Windows_python::Package::Pip { proxy => $pypi_proxy, }

  windows_python::package::pip { 'WMI': version => latest,  }

  $defaults = { 'tag' => 'pip-nova-dependencies', }

  case $version_parts[0] {
    '2013': {
      case $version_parts[1] {
        '1': {
          # Grizzly
          $pip_dependencies = {
            'SQLAlchemy'            => { version => '0.7.8',  },
            'Cheetah'               => { version => '2.4.4',  },
            'amqplib'               => { version => '0.6.1',  },
            'anyjson'               => { version => '0.2.4',  },
            'argparse'              => { version => 'latest', },
            'boto'                  => { version => 'latest', },
            'eventlet'              => { version => '0.9.17', },
            'kombu'                 => { version => '1.0.4',  },
            'routes'                => { version => '1.12.3', },
            'WebOb'                 => { version => '1.2.3',  },
            'PasteDeploy'           => { version => '1.5.0',  },
            'Paste'                 => { version => 'latest', },
            'sqlalchemy-migrate'    => { version => '0.7.2',  },
            'netaddr'               => { version => '0.7.6',  },
            'suds'                  => { version => '0.4',    },
            'paramiko'              => { version => '1.8.0',  },
            'pyasn1'                => { version => 'latest', },
            'Babel'                 => { version => '0.9.6',  },
            'iso8601'               => { version => '0.1.4',  },
            'httplib2'              => { version => 'latest', },
            'setuptools-git'        => { version => '0.4.0',  },
            'python-cinderclient'   => { version => '1.0.1',  },
            'python-quantumclient'  => { version => '2.2.0',  },
            'python-glanceclient'   => { version => '0.5.0',  },
            'python-keystoneclient' => { version => '0.2.0',  },
            'stevedore'             => { version => '0.7',    },
            'websockify'            => { version => '0.4.0',  },
            'oslo.config'           => { version => '1.1.0',  },
         }
         create_resources('windows_python::package::pip', $pip_dependencies, $defaults)
        }
        '2': {
          # Havana
          $pip_dependencies = {
            'pbr'                   => { version => '0.5.21', },
            'SQLAlchemy'            => { version => '0.7.8',  },
            'amqplib'               => { version => '1.0.2',  },
            'anyjson'               => { version => '0.3.3',  },
            'argparse'              => { version => '1.1', },
            'boto'                  => { version => '2.4.0',  },
            'eventlet'              => { version => '0.14.0', },
            'Jinja2'                => { version => 'latest', },
            'kombu'                 => { version => '2.4.8',  },
            'Routes'                => { version => '1.12.3', },
            'WebOb'                 => { version => '1.2.3',  },
            'PasteDeploy'           => { version => '1.5.0',  },
            'Paste'                 => { version => 'latest', },
            'sqlalchemy-migrate'    => { version => '0.7.2',  },
            'netaddr'               => { version => 'latest', },
            'suds'                  => { version => '0.4',    },
            'paramiko'              => { version => '1.8.0',  },
            'pyasn1'                => { version => 'latest', },
            'Babel'                 => { version => '1.3',    },
            'iso8601'               => { version => '0.1.8',  },
            'jsonschema'            => { version => '1.3.0',  },
            'python-cinderclient'   => { version => '1.0.6',  },
            'python-neutronclient'  => { version => '2.3.0',  },
            'python-glanceclient'   => { version => '0.9.0',  },
            'python-keystoneclient' => { version => '0.3.2',  },
            'six'                   => { version => '1.4.1',  },
            'stevedore'             => { version => '0.10',   },
            'websockify'            => { version => '0.5.1',  },
            'oslo.config'           => { version => '1.2.0',  },          
          }
          create_resources('windows_python::package::pip', $pip_dependencies, $defaults)
        }
        default: {}
      }
    }
    default: { }
  }
}
