# Class: selinux::config
#
# Description
#  This class is designed to configure the system to use SELinux on the system
#
# Parameters:
#  - $mode (enforced|permissive|disabled) - sets the operating state for SELinux.
#
# Actions:
#  Configures SELinux to a specific state (enforced|permissive|disabled)
#
# Requires:
#  This module has no requirements
#
# Sample Usage:
#  This module should not be called directly.
#
class selinux::config(
  $mode=undef
) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  $modes = [ 'enforcing', 'permissive', 'disabled' ]
  if ! ( $mode in $modes ) {
    fail('You must specify a mode (enforced, permissive, or disabled)')
  }
  if $::selinux_current_mode != $mode {
    if $::selinux_current_mode == 'disabled' or $mode == 'disabled' {
      notify {"A reboot is required to change from ${::selinux_current_mode} to ${mode}": }
    } else {
      exec { "setenforce-${mode}":
        # TODO: can't do setenforce disabled
        command => "setenforce ${mode}",
      }
    }
  }

  file { '/etc/sysconfig/selinux':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('selinux/sysconfig_selinux.erb')
  }
}
