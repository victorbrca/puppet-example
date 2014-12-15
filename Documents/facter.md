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