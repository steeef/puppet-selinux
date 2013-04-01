# == Class: selinux::install
class selinux::install {
  package { [
    'policycoreutils',
    'checkpolicy',
  ]:
    ensure => present,
  }
}

