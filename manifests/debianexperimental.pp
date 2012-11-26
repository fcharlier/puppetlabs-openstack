class openstack::debianexperimental () {
  file { '/tmp/gplhost-keyring.deb':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 644,
    source => 'puppet:///modules/openstack/gplhost-archive-keyring_20100926-1_all.deb',
  }

  package { 'gplhost-archive-keyring':
    ensure   => installed,
    provider => 'dpkg',
    source   => '/tmp/gplhost-keyring.deb',
    require  => File['/tmp/gplhost-keyring.deb']
  }

  apt::source { 'debian_experimental_gplhost':
    location          => 'http://ftparchive.gplhost.com/debian',
    release           => 'experimental',
    repos             => 'main',
    required_packages => 'gplhost-archive-keyring'
  }

  apt::source { 'debian_experimental':
    location => 'http://ftp2.fr.debian.org/debian',
    release  => 'experimental',
    repos    => 'main'
  }

  apt::pin { 'libvirt':
    release  => 'experimental',
    priority => 900,
    package  => '*libvirt*',
    order    => 99
  }


}
