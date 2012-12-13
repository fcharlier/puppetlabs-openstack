class openstack::debianexperimental () {
  file { '/tmp/gplhost-keyring.deb':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/openstack/gplhost-archive-keyring_20100926-1_all.deb',
  }

  exec { 'install_gplhost_keyring':
    command => 'dpkg -i /tmp/gplhost-keyring.deb',
    require => File['/tmp/gplhost-keyring.deb']
  }

  apt::source { 'debian_experimental_gplhost':
    location => 'http://ftparchive.gplhost.com/debian',
    release  => 'openstack',
    repos    => 'main',
    require  => exec['install_gplhost_keyring']
  }

  apt::source { 'wheezy_backports_gplhost':
    location => 'http://ftparchive.gplhost.com/debian',
    release  => 'wheezy-backports',
    repos    => 'main',
    require  => exec['install_gplhost_keyring']
  }

  apt::source { 'debian_experimental':
    ensure   => absent,
    location => 'http://ftp2.fr.debian.org/debian',
    release  => 'experimental',
    repos    => 'main'
  }

#  apt::pin { 'gplhost':
#    origin => 'GPLHost',
#    priority => 990,
#  }
  file { '/etc/apt/preferences.d/gplhost_manual.pref':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => '
# gplhost
Package: *
Pin: release o=GPLHost
Pin-Priority: 1000
'
  }

  File['/etc/apt/preferences.d/gplhost_manual.pref'] -> Package<| |>

  apt::pin { 'libvirt':
    release  => 'unstable',
    priority => 990,
    packages => '*libvirt*',
  }

  apt::source { 'debian_sid':
    location => 'http://ftp2.fr.debian.org/debian',
    release  => 'sid',
    repos    => 'main'
  }


}
