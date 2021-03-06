class puppet::master::config (
  $puppetdb             = 'true',
  $reports              = 'store',
  $storeconfigs         = 'true',
  $storeconfigs_backend = 'puppetdb',
  $puppetdb_server      = undef,
  $puppetdb_port        = undef,
  $ca_hostname          = undef,
  $report_server        = undef,
  $hiera_data_dir       = undef,
  $hiera_redis          = true,
) inherits puppet::params {

  include puppet::configfile
  include stdlib

  validate_string($puppetdb, $reports, $storeconfigs)

  if (str2bool($storeconfigs)) {
    validate_string($storeconfigs_backend)
  }

  if (str2bool($puppetdb)) {
    validate_string($puppetdb_server, $puppetdb_port)
    if ($puppetdb_server == undef or $puppetdb_port == undef) {
      fail('Must specify puppetdb server and port')
    }
    $routesensure = 'present'
    $dbconfensure = 'present'
  } else {
    $routesensure = 'absent'
    $dbconfensure = 'absent'
  }

  if $hiera_data_dir != undef {
    validate_string($hiera_data_dir)
    $hiera_data_dir_real = $hiera_data_dir
  } else {
    $hiera_data_dir_real = '/etc/puppet/data'
  }

  realize File[$puppet::params::config]

  augeas { 'puppet-master-config':
    context => "/files${puppet::params::config}",
    changes => [
      "set master/reports '${reports}'",
      "set master/storeconfigs ${storeconfigs}",
      "set master/storeconfigs_backend ${storeconfigs_backend}",
    ],
  }

  if $ca_hostname != undef {
    if $ca_hostname == $::fqdn {
      $is_ca = 'true'
    } else {
      $is_ca = 'false'
    }

    augeas { 'puppet-master-ca_hostname':
      context => "/files${puppet::params::config}",
      changes => [
        "set main/ca_server ${ca_hostname}",
        "set master/ca ${is_ca}",
      ],
    }
  }

  if $report_server != undef {
    augeas { 'puppet-master-report_server':
      context => "/files${puppet::params::config}",
      changes => [
        "set master/report_server ${report_server}",
      ],
    }
  }

  file { '/etc/puppet/fileserver.conf':
    ensure => present,
    owner  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppet/etc/puppet/fileserver.conf',
  }

  file { '/etc/puppet/auth.conf':
    ensure => present,
    owner  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppet/etc/puppet/auth.conf',
  }

  file { '/etc/puppet/puppetdb.conf':
    ensure  => $dbconfensure,
    owner   => 'root',
    mode    => '0644',
    content => template('puppet/puppetdb.conf.erb'),
  }
  file { '/etc/puppet/routes.yaml':
    ensure => $routesensure,
    owner  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml',
  }

  $redis_server = "${::location}-p-redis-01.${::domain}"

  file { '/etc/puppet/hiera.yaml':
    ensure  => 'present',
    owner   => 'root',
    mode    => '0644',
    content => template('puppet/hiera.yaml.erb'),
  }

  file { $hiera_data_dir_real:
    ensure => 'directory',
    owner  => 'puppet',
    mode   => '0755',
  }

  File[$puppet::params::config] -> Augeas['puppet-master-config']

}
