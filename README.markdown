# SELinux Puppet Module

This module can set SELinux and deploy SELinux type enforcement files (.te)
modules to running RHEL based system. Forked from jfryman, we added:
- all enforcing/permissive/disabled switch covered
- ability to select selinux module directory
- a file context file (.fc) can be used with a type enforcement (.te) one
- many bug fixes
- puppet lint compliant code
- full spec testing

# Requirements
- puppetlabs/stdlib >= 3.0.0
- RedHat/Fedora based distribution

# Installation
<pre>
puppet module install spiette/selinux
</pre>

# Synopsys
## selinux class
<pre>
include selinux
</pre>

<pre>
class { 'selinux':
  mode => 'permissive'
}
</pre>
## selinux::boolean
<pre>
selinux::boolean { 'allow_ssh_keysign':
  ensure => present
}
</pre>

## selinux::module
<pre>
selinux::module { 'rsynclocal':
  source   => 'puppet:///modules/site/rsynclocal.te'
  fcontext => true,
}
</pre>

The `fcontext` parameter is to specify whether or not a .fc file will be looked
for in the same directory than the .te file. Defaults to false. The `source`
parameter for selinux::module is facultative. If you invoke it like this:
<pre>
selinux::module { 'rsynclocal':
  fcontext => true,
}
</pre>
A .te and a .fc file will be taken in puppet:///modules/selinux/rsynclocal.te
and puppet:///modules/selinux/rsynclocal.fc.

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

# SELinux reference

* *selinux(8)*
* *man -k selinux* for module specific documentation
* *audit2allow(1)* to build your modules with audit log on permissive mode

# Contribute

Please see the [Github](https://github.com/spiette/puppet-selinux) page. We'll review  pull requests and bug reports. If the module don't do what you want, please explain your use case. Testing on Debian-based distributions is welcome.

# Credits
- Maintainer: Simon Piette <piette.simon@gmail.com>
- Original module from James Fryman <james@frymanet.com> https://github.com/jfryman/puppet-selinux
- selinux::booleans is a contribution from GreenOgre <aggibson@cogeco.ca> 
- Concepts incorporated from:
http://stuckinadoloop.wordpress.com/2011/06/15/puppet-managed-deployment-of-selinux-modules/
