Facter
=======
[Facter 2.3: Documentation Index](https://docs.puppetlabs.com/facter/2.3/)
[List of core facts](Facter 2.3: Documentation Index)

Gathers node system information that can be used by Puppet. It discovers and reports per-node facts, which are available in your Puppet manifests as variables.

Facter assigns these values to variables, which are accessible to puppet as top scope variables.

```bash
$ facter osfamily
RedHat
```

```bash
$ facter | grep mem
memoryfree => 531.05 MB
memoryfree_mb => 531.05
memorysize => 590.26 MB
memorysize_mb => 590.26
```

**Example:** Case statement using facter variable

```puppet
case $::osfamily {
    'RedHat': {
        $ssh_name = ' sshd'
    }
    'Debian': {
        $ssh_name = 'ssh'
    }
}
```

Custom Facts
------------

[Facter 2.3: Custom Facts Walkthrough](https://docs.puppetlabs.com/facter/2.3/custom_facts.html)

Custom facts are Ruby blocks of code that when executed creates a fact. Usually shell commands are executed in the Ruby code to get system information

You can enable custom facts by: 
- Setting the $LOAD_PATH variable or the ruby library load path
- Environment variable FACTERLIB
- Be distributed via pluginsync. This requires `pluginsync=true` in the `[main]` section of `puppet.conf`


```ruby
# hardware_platform.rb

Facter.add('hardware_platform') do
  setcode do
    Facter::Core::Execution.exec('/bin/uname --hardware-platform')
  end
end
```

External Facts
--------------

Enables scripts written in other languages to be executed on the node (during an agent run) and load fact data. The best way to distribute external facts is with pluginsync.

To add external facts to your puppet modules, just place them in `<MODULEPATH>/<MODULE>/facts.d/` or `<MODULEPATH>/<MODULE>/lib/facter/`. The config  `pluginsync=true` in the `[main]` section of `puppet.conf` also needs to be enabled. 

#### Structured Data Facts

You can also set your own facts, which can be used to define nodes.

- Puppet Enterprise
    - /etc/puppetlabs/facter/facts.d/[file].txt
- Puppet opensource
    - ?? /etc/facter/facts.d/[file].txt

```
key1=value1
key2=value2
key3=value3
```



facter -p