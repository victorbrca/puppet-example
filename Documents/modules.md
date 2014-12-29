# Modules

### Naming

- Must begin with a lowercase letter
- Name can include lowercase letters, numbers and underscores
- The module names `main` and `settings` cannot be used 

### Folder Structure 

/etc/puppet/modules/[module_name]

Puppet Enterprise
/etc/puppetlabs/puppet/modules/[module_name]

```
├── files
├── manifests
│   ├── groups
│   │   ├── finance.pp (example)
│   │   └── wheel.pp (example)
│   └── init.pp
├── templates
└── tests
    └── init.pp
```

- files - Stores files needed by nodes
- manifests - Should always have a init.pp
- templates - 
- tests - Used to test modules

#### init.pp
```puppet
class localusers {
	user 
...
}
```

#### groups/wheel.pp

```puppet
class localusers::groups::wheel {
...
}
```
*** Note:***  *The "::" is autoload. Refers to subfolders in the main module*

#### tests/init.pp

```puppet
include localusers
include localusers::groups::wheel
```
