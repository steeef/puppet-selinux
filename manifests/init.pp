# == Class: selinux
#
#  This class manages SELinux on RHEL based systems.
#
# === Parameters:
#  [*mode*]
#    (enforced|permissive|disabled)
#    sets the operating state for SELinux.
#
# === Requires:
#  - [puppetlab/stdlib]
#
# == Example
#
#  include selinux
#
class selinux(
  $mode = 'enforcing'
) {
  include stdlib
  include selinux::params

  file { $selinux::params::modules_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
  }

  anchor { 'selinux::begin': } ->
  class { 'selinux::config':
      mode => $mode,
  } ->
  anchor { 'selinux::end': }
}
