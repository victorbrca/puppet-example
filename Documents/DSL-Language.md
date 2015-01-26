DSL - Domain Specific Language
=============================

Variables
----------

[Language: Variables](https://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html)

- Are constants and cannot be reassigned a value within the given scope (however they can be re-assigned in a different scope level)
- Variable names are case-sensitive and can include alphanumeric characters and underscores. Dashes should NOT be used, and the variable name `$string` is reserved. Puppet 3.7 deprecates the use of variable names starting with uppercase letters.
- Qualified variable names are prefixed with the name of their scope and the :: (double colon) namespace separator. (For example, the $vhostdir variable from the apache::params class would be $apache::params::vhostdir)
- You can access out-of-scope variables from named scopes by using their qualified names `$vhostdir = $apache::params::vhostdir`
- Inside a double-quoted string, you can optionally surround the name of the variable (the portion after the $) with curly braces (${var_name}). This syntax helps to avoid ambiguity and allows variables to be placed directly next to non-whitespace characters. These optional curly braces are only allowed inside strings
- variable assignments are parse-order dependent. This means you cannot resolve a variable before it has been assigned

#### Single Quotes vs. Double Quotes

- Double quotes evaluate the value of the variable
- Single quotes interpret the variable name

**Example:** the second option will display "$var There", while the third will display "Hello There"

```puppet
$var = "Hello"
$var1 = '$var There'
$var1 = "$var There"
```

#### Appending Values

Example: The final value or `var` is `['banana','apple','pear']`

```puppet
$var = ['banana','apple']
$var += ['pear']
```

### Scopes

https://docs.puppetlabs.com/puppet/latest/reference/lang_scope.html


#### Top scope

Code that is outside any class definition, type definition, or node definition exists at top scope. Variables and defaults declared at top scope are available everywhere. For example, variables defined in `site.pp` before any node definition.

The can be referred to with a double `::`, like `$::osfamily`.

Variables from 'facter' are top scope variables. 

#### Node Scope

Variables defined within the specific node definition.

Code inside a node definition exists at node scope. Note that since only one node definition can match a given node, only one node scope can exist at a time.

Variables and defaults declared at node scope are available everywhere except top scope.

A node variable can overwrite a top scope variable (unless the variable is called with `::`).

#### Local (Class) Scope

Code inside a class definition or defined type exists in a local scope.

Variables and defaults declared in a local scope are only available in that scope and its children.

Variables and defaults declared at node scope can override those received from top scope. Those declared at local scope can override those received from node and top scope, as well as any parent scopes (Puppet will use the “most local” one).

A local variable can overwrite top (unless the variable is called with `::`) and node scope variables.

Syntax

```puppet
$content = "some content\n"
```

#### Variable Scope Origin

**Top scope variables are defined in:**
- site.pp outside a node definition
- Puppet Enterprise Console
- External Node Classifier Data
- facts

**Node Scope variables are defined in:**
- site.pp inside a node definition

**Local scope variables are defined in:**
- a class definition
- a defined type


#### Accessing Local Variables from Other Scopes

You can access variables from other classes by calling the path with `::` (like `module_name::class::variable`). 

For example, take the SSH module with the following structure:

```bash
# tree ssh
.
├── manifests
│   ├── params.pp
│   ├── ssh.pp
└── tests
    └── ssh.pp
```

The variable is defined within `params.pp`:

```puppet
# manifests/params.pp 
class base::params {
    case $::osfamily {
        'RedHat': { $ssh_name = 'sshd' }
        'Debian': { $ssh_name = 'ssh' }
        default: { warning('OS not supported by puppet modle SSH') }
    }
}
```

The `ssh.pp` file calls it:

```puppet
# manifests/ssh.pp
class base::ssh {
    service { 'sshd':
        name    => $base::params::ssh_name,
        ensure  => running,
        enable  => true,
    }
}
```

Don't forget to include both classes when testing (and on your `site.pp` when deploying it):

```puppet
# tests/ssh.pp 
include base::params
include base::ssh
```

Conditional Statements
----------------------

[Language: Conditional Statements](https://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html)

### if

[If Statements](https://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html#if-statements)


**Syntax**

```puppet
if condition {
	code
} elsif condition {
	code
} else {
	code
}
```

**Example 1**

```puppet
$apache = true

if $apache {
	file {'/etc/motd': ensure => present, content => 'Apache web server', }
} else {
	file {'/etc/motd': ensure => present, content => 'Unassigned server', }
}
```

**Example 2** - Using regex

```puppet
if $::hostname =~ /^puppetnode(\d+)/ {
    notice("You have arrived at server $0 ")
    # $0 is only available in this block
}
```

**Example 3**

```puppet
if $color and $sound {
    do something
}

if ($color == 'red') or ($sound == 'loud') {
    do something
}

if ($color == 'blue') and ($sound == 'loud') {
    do something
}
```

### unless

[Unless Statements](https://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html#unless-statements)

**Example**
```puppet
Unless $memorytotal > 1024 {
	$maxclient = 300
}
```

### case

[Case Statements](https://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html#case-statements)

- Do not require default matches (compiling will not fail)
- Useful for when setting a block of code of more than one variable

**Format**

```puppet
case $test_variable { 
	'[Match Pattern 1]': {
		$result_variable = 'desired value 1'
	}
	'[Match Pattern 2]': {
		$result_variable = 'desired value 2'
	}
	'default': {
		warning('Value of test_variable did not match')
	}

	resource_type { 'resource-name':
		name => $result_variable,
	}
}
```

**Example 1**

```puppet
case $osfamily { 
	'RedHat': {
		$ssh_name = ' sshd'
	}
	'Debian': {
		$ssh_name = 'ssh'
	}
	'default': {
		warning('OS family does not match')
	}

	service { 'resource-name':
		name => $ssh_name,
		ensure => running,
		enable => true,
	}
}
```

**Example 2**

```puppet
case $operatingsystem {
	centos, redhat: { $service_name = 'ntpd' }
	debian, ubuntu: { $service_name = 'ntp' }
}

package { 'ntp':
	ensure => installed,
}

service { 'ntp':
	name		=> $service_name,
	ensure		=> running,
	enable		=> true,
	subscribe	=> File['ntp.conf'],
}
```

**Example 3**

```puppet
case $osfamily {
                'RedHat': { $ssh_name = 'sshd' }
                'Debian': { $ssh_name = 'ssh' }
                default: { fail('OS not supported by puppet modle SSH') }
}
```

### selector

[Selector statements](https://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html#selectors)

Selector statements are similar to case statements, but return a value instead of executing a code block.

- Should be used where a plain value is expected
- Ideal for setting variables or attributes in line
- If there's no match, puppet compiling will fail (while 'if statements' will not fail). So it's best practice to always use 'default'
- Selector expressions cannot be used within the "case" of another selector statement, however they can be used within a case statements case

**Syntax**

```puppet
control variable ? {
    case => 'value'
    case => 'value'
}
```

**Example 1**

```puppet
$ssh_name = $osfamily ? {
	'RedHat'	=> 'sshd',
	'Debian'	=> 'ssh',
	default		=> 'value',
}
```

**Example 2**

***Note:*** If there's no match, it will fail as we don't have a default value

```puppet
$package = $osfamily ? {
	'RedHat' => 'http',
	'Debian'  => 'apache2',
}

package { $package:
	ensure => installed,
}
```

**Example 3**

```puppet
package { 'resource-title':
	name = $::osfamily ? {
		'RedHat' => 'http',
		'Debian'  => 'apache2',
		default    => 'httpd',
	},
	ensure => installed,
}
```

Functions
-------------

[Language: Functions](https://docs.puppetlabs.com/puppet/latest/reference/lang_functions.html)
[Function Reference](https://docs.puppetlabs.com/references/latest/function.html)

Functions are pre-defined chunks of Ruby code which run during compilation. Most functions either return values or modify the catalog.

Puppet includes several built-in functions, and more are available in modules on the Puppet Forge, particularly the puppetlabs-stdlib module. You can also write custom functions and put them in your own modules.

Functions execute on the Puppet master. They do not execute on the Puppet agent. Hence they only have access to the commands and data available on the Puppet master host.

**Syntax**

```puppet
file {'/etc/ntp.conf':
      ensure  => file,
      content => template('ntp/ntp.conf'),
}
```

### Function Types

#### rvalue Functions

Rvalues return values and can only be used in a statement requiring a value, such as an assignment or a case statement.

**Examples of rvalue functions**

`file`

Loads a file from a module and returns its contents as a string.

`template`

Loads an ERB template from a module, evaluates it, and returns the resulting value as a string.

`md5`

Returns a MD5 hash value from a provided string.


#### Statement Functions

Statements stand on their own and do not return arguments; they are used for performing stand-alone work like importing

***Custom Functions***

https://docs.puppetlabs.com/guides/custom_functions.html


Resource Collectors
-------------------

[Language: Resource Collectors](https://docs.puppetlabs.com/puppet/latest/reference/lang_collectors.html)

Resource collectors allow you to do a "find and replace" on already defined resource attributes. 

**Syntax**

```puppet
resource type <| attribute [operator] value |> {
    attribute 1 => 'value',
    attribute 2 => 'value',
}
```

For example, the code below will search attributes in the local base catalog and substitute groups that are set to 'root' for the group 'jeff':

```puppet
class base::group {
	File <| group == "root" |> {
		group => "jeff",
	}
}
```

Search operators:

- ==
- !=
- and
- or 

**Example:** Adds the group 'osinstall' to all `file` resource type in the catalog.

```puppet
File <| |> {
    group += ['osinstall'],
}
```

Resource collectors can be declared in a class and then called from an init.pp.

```puppet
$ cat manifests/rc.pp
class filedemo::rc {
	File <| group == "root" |> {
		group => "jeff",
	}
}
```

```puppet
$ cat tests/rc.pp
include filedemo::rc
include filedemo
```