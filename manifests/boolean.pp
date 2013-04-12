# == Definition: selinux::boolean
#
#  This class will set the state of an SELinux boolean. All pending values are
#  written to the policy file on disk, so they will be persistant across
#  reboots. Ensure that the manifest notifies a related service as a restart
#  for that service may be required.
#
# === Parameters
#  [*ensure*]
#    (on|off) - Sets the current state of a particular SELinux boolean
#
# === Example
#
#  selinux::boolean { 'named_write_master_zones':
#    ensure => "on",
#  }
#
define selinux::boolean (
  $ensure = 'undef'
) {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  case $ensure {
    on, true, present: {
      exec { "setsebool -P '${name}' true":
        unless => "getsebool '${name}' | awk '{ print \$3 }' | grep on",
      }
    }
    off, false, absent: {
      exec { "setsebool -P '${name}' false":
        unless => "getsebool '${name}' | awk '{ print \$3 }' | grep off",
      }
    }
    default: { err ( "Unknown or undefined boolean state ${ensure}" ) }
  }
}
