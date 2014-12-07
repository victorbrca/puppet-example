# DSL - Domain Specific Language


#### Array

Examples:

```
user { 'jeff':
	ensure => present,
	groups => [ 'wheel', 'finance'],
}
```

```
package { ['openssh','mysql']:
	ensure => present,
}
```

## Conditional Statements

#### case

Format
```
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
```
case $osfamily { 
	'RedHat': {
		$ssh_name = ' sshd'
	}
	'Debian': {
		$ssh_name = ' ssh'
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

```
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