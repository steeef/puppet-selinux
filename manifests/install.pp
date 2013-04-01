# == Class: selinux::install
class selinux::install {
  package { [
    'policycoreutils',
    'checkpolicy',
    'selinux-policy-devel',
  ]:
    ensure => present,
  }
  if $selinux::installmake {
    package { 'make':
      ensure => present,
    }
  }
}

