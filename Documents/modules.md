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

autoloader requries class name to have the same name as filename

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

## Creating and Uploading Modules for Puppet Forge

**Preparing a Module**

- Make sure proper directory structure exists
- Populate metadata.json with dependencies and basic module information (puppet certification exam still refers to the old `modulefile`)
- Remove all symlinks
- Run the command `puppet module build [dir]`

**Defining Dependencies**

Using 1.2.x will match 'x' as a wildcard, however that cannot be used with operator ranges (`<, >, =`)

```puppet
# metadata.json
"dependencies":[
{"name":"ownership/module","version_requirement":">=0.1.0"}
{"name":"ownership/module2","version_requirement":">=0.1.0<0.5.0"}
]
```