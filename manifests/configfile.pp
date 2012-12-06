class puppet::configfile inherits puppet::params {
  
  @file { $puppet::params::config:
    ensure  => present,
    replace => false,
    source  => 'puppet:///modules/puppet/etc/puppet/puppet.conf',
    owner   => 'root',
    mode    => '0644',
  }
}
