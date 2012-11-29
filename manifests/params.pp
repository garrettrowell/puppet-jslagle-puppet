class puppet::params {
  case $::osfamily {
    Redhat: {
      $masterpkg = "puppetmaster"
      $clientpkg = "puppet"
      $dbpkg = "puppetdb"
      $agentsvc = "puppet"
    }

    Debian: {
      $masterpkg = "puppetmaster"
      $clientpkg = "puppet"
      $dbpkg = "puppetdb"
      $agentsvc = "puppet"
    }

    default: {
      err("OS Family ${::osfamily} not supported")
    }
  }

  # Packages are more likely to change, so we'll leave them in the
  # case - the config files are pretty consistent
  $config = "/etc/puppet/puppet.conf"
 
}
