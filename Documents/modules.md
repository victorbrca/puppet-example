Modules
=======

Modules are self-contained bundles of code and data. You can write your own modules or you can download pre-built modules from the Puppet Forge.

Nearly all Puppet manifests belong in modules. The sole exception is the main site.pp manifest, which contains site-wide and node-specific code.

Modules are how Puppet finds the classes and types it can use — it automatically loads any class or defined type stored in its modules.

#### Naming

- Must begin with a lowercase letter
- Name can include lowercase letters, numbers and underscores
- The module names `main` and `settings` cannot be used 

#### Folder Structure

Module location:
- Puppet Open Source
	- /etc/puppet/modules/[module_name]
- Puppet Enterprise
	- /etc/puppetlabs/puppet/modules/[module_name]

**Structure**

```
├── facts.d
├── files
├── lib
├── manifests
├── spec
├── templates
└── tests
```

- **facts.d** - Contains external facts, which are an alternative to Ruby-based custom facts
- **files** - Contains static files, which managed nodes can download
- **lib** - Contains plugins, like custom facts and custom resource types
- **manifests** - Contains all of the manifests in the module. Should always have a init.pp
- **spec** - Contains spec tests for any plugins in the lib directory
- **templates** - Contains templates, which the module’s manifests can use
- **tests** - Contains examples showing how to declare the module’s classes and defined types. Can also be used to test modules

**Example:** Simple example of a folder structure

```
├── files
│   ├── bashrc
├── manifests
│   ├── groups
│   │   ├── finance.pp
│   │   └── wheel.pp
│   └── init.pp
├── templates
└── tests
    └── init.pp
```

Autoloader requries class name to have the same name as filename

**Example:** Path and class name

```puppet
# modules/localusers/manifests/groups/wheel.pp
class localusers::groups::wheel {
	...
}
```

*** Note:***  *The "::" is part of the autoload. It refers to subfolders in the main module*

**Example :** A `init.pp` file in the tests folder that has the include as it would on `site.pp`

```puppet
# tests/init.pp
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