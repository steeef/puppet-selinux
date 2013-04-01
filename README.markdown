# SELinux Puppet Module

This module can set SELinux and deploy SELinux type enforcement files (.te)
modules to running RHEL based system. Forked from jfryman, we added:
- all enforcing/permissive/disabled switch covered
- ability to select selinux module directory
- many bug fixes
- puppet lint compliant code
- full spec testing

# Requirements
- puppetlabs/stdlib >= 3.0.0
- RedHat/Fedora based distribution

# Synopsys
<pre>
include selinux
selinux::module { 'rsynclocal':
    source => 'puppet:///modules/site/rsynclocal.te'
}
</pre>

<pre>
class { 'selinux':
  mode => 'permissive'
}
</pre>

<pre>
selinux::module { 'rsynclocal':
  ensure => 'disabled'
}
</pre>

<pre>
selinux::module { 'rsynclocal':
  ensure => 'absent'
}
</pre>

# Caveats
The semodule command is slow. Your puppet run will be slower if you keep selinux::module disabled instead of remove.

# Credits
Original module from James Fryman <james@frymanet.com>
https://github.com/jfryman/puppet-selinux
selinux::booleans is a contribution from GreenOgre <aggibson@cogeco.ca> 
Concepts incorporated from:
http://stuckinadoloop.wordpress.com/2011/06/15/puppet-managed-deployment-of-selinux-modules/
