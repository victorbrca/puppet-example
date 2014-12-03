# Modules

### Folder Structure 

```
/etc/puppetlabs/puppet/modules/localusers

├── files
├── manifests
│   ├── groups
│   │   ├── finance.pp (example)
│   │   └── wheel.pps (example)
│   └── init.pp
├── templates
└── tests
```

- files - Stores files needed by nodes
- manifests - Should always have a init.pp
- templates - 
- tests - 

#### init.pp
```
class localusers {

}
```

#### groups/wheel.pp
```
class localusers::groups::wheel {

}
```

Inspect module files for syntax errors

```
# puppet parser validate init.pp 
# echo $?
0

# puppet parser validate groups/wheel.pp 
Error: Could not parse for environment production: Syntax error at ':' at /etc/puppetlabs/puppet/modules/localusers/manifests/groups/wheel.pp:1
```