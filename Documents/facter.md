# Facter

Gathers system information that can be used by Puppet (like when creating a class) and assigns then to variables.

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

## Variables

https://docs.puppetlabs.com/puppet/latest/reference/lang_facts_and_builtin_vars.html

- Facter variables are top scope variables
- They can be referred to with `$::fact` or `$facts['fact']`

```puppet
if "$::osfamily" == 'redhat' {
    ...
}

if $facts['osfamily'] == 'redhat' {
    ...
}
```
