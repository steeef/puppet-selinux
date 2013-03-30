# == Class: selinux::install
class selinux::install {
  package { [
    'selinux-policy-devel',
    'checkpolicy',
  ]:
    ensure => present,
  }
}

