# == Class: selinux::install
class selinux::install {
  package { 'selinux-policy-devel':
    ensure => present,
  }
}

