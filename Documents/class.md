Class
=====

[Language: Classes](https://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html)
[Learning Puppet — Modules and Classes](https://docs.puppetlabs.com/learning/modules1.html#classes)

Classes are named block of codes stored in modules. They are assigned to each node from the node definition (from manifests or from an ENC).

**Syntax**

```puppet
class [class name] {
    code block
}
```

**Example 1:** A simple 'ntp' class

```puppet
class ntp {
	package {'ntp':
    	ensure => present,
	}
}
```

**Example 2:** A users class (`users.pp`) in the base module folder (`/etc/puppet/modules/base`)

```puppet
class base::users {
	user { 'jeff':
    	ensure => present,
		shell      => '/bin/bash'
		home       => '/home/jeff',
		gid 	   => 'wheel',
		managehome => true,
	}
}
```

##### Class Declaration

Classes are usually called from the node definition (for example, site.pp) with the include function, or with a resource like declaration class.

```puppet
# /etc/puppet/manifests/site.pp

node default {
	include ntp
    class { 'base::users': user => 'jeff', }
}
```

You can also use `require`, `contain` or `hiera_include` to declare classes.

##### Naming

- Must begin with a lowercase letter
- Name can include lowercase letters, numbers and underscores
- The class names `main` and `settings` cannot be used

### Inheritance

[Language: Classes - Inheritance](https://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#inheritance)

Class inheritance should be avoided. It should be used mainly to avoid repetition of code.

Cons:
- Decreases modularity
- Increases compile time
- To let a “params class” provide default values for another class’s parameters

Pros:
- Allows to extend classes and use the local scope variables

When to use:
- Override resource attributes
- Avoid repetition of code

***Note:*** Inheriting a class will also declare it, even if it was not declared

```puppet
# Apache file
class apache {
    service {'apache':
        require => Package['httpd'],
    }
}

# Apache SSL file
class apache::ssl inherits apache {
    # host certificate is required for SSL to function
    Service['apache'] {
        require +> [ File['apache.pem'], File['httpd.conf'] ],
        # Since `require` will retain its previous values, this is equivalent to:
        # require => [ Package['httpd'], File['apache.pem'], File['httpd.conf'] ],
    }
}
```
***Need to review the next 2 examples***

**Example 1:** Calling a local scope variable from another class

```puppet
# manifests/params.pp 
class base::params {
	case $::osfamily {
        'RedHat': { $ssh_name = 'sshd' }
        'Debian': { $ssh_name = 'ssh' }
        default: { warning('OS not supported by puppet module SSH') }
    }
}

# manifests/ssh.pp
class base::ssh {
    service { 'sshd':
        name    => $base::params::ssh_name,
        ensure  => running,
        alias   => 'ssh-service-name-two',
        enable  => true,
    }
}
```

The main `site.pp` must include the class being called.

```puppet
# ../../manifests/site.pp 
node "xyz" {
    include base::params
    include base::ssh
}
```

**Example 2:** Inheriting a class

```puppet
# manifests/params.pp 
class base::params {
    case $::osfamily {
        'RedHat': { $ssh_name = 'sshd' }
        'Debian': { $ssh_name = 'ssh' }
        default: { warning('OS not supported by puppet module SSH') }
    }
}


# manifests/ssh.pp
class base::ssh inherits base::params {
    service { 'sshd':
        name    => $base::params::ssh_name,
        ensure  => running,
        alias   => 'ssh-service-name-two',
        enable  => true,
    }
}
```

No need to use `include base::params` in the main `site.pp`.

```puppet
# ../../manifests/site.pp
node "xyz" {
    include base::ssh
}
```

## Class Parameter (Automatic Parameter Lookup)

Lets the class ask for data to be passed in at the time that it’s declared, and it can use that data as normal variables throughout its definition.

**Example 1:** In this example, the value of `$parameter_one`  gets set when `myclass` is eventually declared.

```puppet
# Class definition:
class myclass ($parameter_one = "default text") {
    file {'/tmp/foo':
        ensure  => file,
        content => $parameter_one,
    }
}
```

The automatic parameter lookup also works with Hiera. It will populate date in the following order:
- Looks for parameters passed during the class declaration (like in `site.pp`)
- Does a hiera lookup for `<CLASS NAME>::<PARAMETER NAME>`
- Uses the default parameter if defined in the class

**Example 2:** Define requirements within a class

On this example, the parameter `$ntppackage` is defined as required and has its default value from the variable `$package_name` in `ntp::params`:

```puppet
class ntp ($ntppackage => $ntp::params::package_name ) inherits ntp::params {
	package { 'ntp_package':
		name  => $ntppackage,
		ensure => present,
	}
}
```

The value was defined in `ntp::params`:

```puppet
class ntp::params {
	$package_name = 'ntp'
}
```

However, this allows us to overwrite the value of `$ntppackage` from `site.pp`:

```puppet
class { 'ntp': ntppackage => 'ntpd', }
```

***Need to check sentence below***

Note that the parameter, is not a variable, however it can be assigned the value of a variable:

***site.pp***
```puppet
node "ntp.mydomain.com" {
	$ntppackage = "My package name"
	class { 'ntp': }
}
```

***ntp.pp***
```puppet
class ntp ($ntppackage => $ntppackage) inherits ntp::params {
	package { 'ntp_package':
		name  => $ntppackage,
		ensure => present,
	}
}
```

### Examples of class parameters and scopes

**Example 1:** This will work and will output `Notice: Value is 1`.

```puppet
# site.pp
node default {
	class { 'classparameter': }
}

# classparameter.pp
class classparameter ($value = "1") {
    notify { "Value is $value": }
}
```

**Example 2:** Will fail with `Cannot reassign variable value`

```puppet
# site.pp
node default {
	class { 'classparameter': }
}

# classparameter.pp
class classparameter ($value = "1") {
    $value = "2"
    notify { "Value is $value": }
}
```

**Example 3:** Will work and output will be `Notice: Value is 0`

```puppet
# site.pp
node default {
	class { 'classparameter': value => "0" }
}

# classparameter.pp
class classparameter ($value = "1") {
    notify { "Value is $value": }
}
```

**Example 4a:** Assigning a variable outside of the node declaration will result in a top scope variable.

```
Notice: Value is 1
Notice: Value_top is 0
```

```
# site.pp
$value = "0"
node default {
	class { 'classparameter': }
}

# classparameter.pp
class classparameter ($value = "1") {
        $value_top = $::value
        notify { "Value is $value": }
        notify { "Value_top is $value_top": }

}
```

Output will be:

```
Notice: Value is 1
Notice: Value_top is 0
```

**Example 4b:** However adding the variable to the node definition will result in not being a top scope variable.

```puppet
# site.pp
node default {
    $value = "0"
	class { 'classparameter': }
}
```

```
Notice: Value is 1
Notice: Value_top is
```