# Facter

Gathers system information that can be used by Puppet (like when creating a class)

```
# facter osfamily
RedHat
```

```
# facter | grep mem
memoryfree => 531.05 MB
memoryfree_mb => 531.05
memorysize => 590.26 MB
memorysize_mb => 590.26
```

## Custom Facts

[Facter 2.3: Custom Facts Walkthrough](https://docs.puppetlabs.com/facter/2.3/custom_facts.html)

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
