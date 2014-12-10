# DSL - Domain Specific Language


#### Array

Examples:

```puppet
user { 'jeff':
	ensure => present,
	groups => [ 'wheel', 'finance'],
}
```

```puppet
package { ['openssh','mysql']:
	ensure => present,
}
```

## Conditional Statements

### case

- Do not require default matches (compiling will not fail)
- Usefull for when setting a block of code of more than one variable

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
		Warning('Value of test_variable did not match')
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
		Warning('OS family does not match')
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
### selector value

- Should be used where a plain value is expected
- Ideal for setting variables or attributes in line
- If there's no match, puppet compiling will fail (while 'if statements' will not fail). So it's best practice to always use 'default'

```puppet
$ssh_name = $osfamily ? {
	'RedHat'	=> 'sshd',
	'Debian'	=> 'ssh',
	default		=> 'value',
}
```

**Example 1**

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

**Example 2**

```puppet
package { 'resource-title':
	name => $::osfamily ? {
		'RedHat' => 'http',
		'Debian'  => 'apache2',
		default    => 'httpd',
	},
	ensure => installed,
}
```

### if

**Format**

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

### unless

**Example**
```puppet
Unless $memorytotal > 1024 {
	$maxclient = 300
}
```





