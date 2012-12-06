class puppet::master::config (
  $puppetdb = "true",
  $reports = "store",
  $storeconfigs = "true",
  $storeconfigs_backend = "puppetdb",
  $puppetdb_server = undef,
  $puppetdb_port = undef
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
      fail("Must specify puppetdb server and port")
    }
    $routesensure = "present"
    $dbconfensure = "present"
  } else {
    $routesensure = "absent"
    $dbconfensure = "absent"
  }

  realize File[$puppet::params::config]

  augeas { 'puppet-master-config':
    context => "/files${puppet::params::config}",
    changes => [
      "set master/reports ${reports}",
      "set master/storeconfigs ${storeconfigs}",
      "set master/storeconfigs_backend ${storeconfigs_backend}",
    ],
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
  File[$puppet::params::config] -> Augeas['puppet-master-config']

}
