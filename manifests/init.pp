class puppet {
  include puppet::package
  include puppet::config
  include puppet::service

  Class['puppet::package'] -> Class['puppet::config']
    ~> Class['puppet::service']

}
