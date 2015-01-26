Defined Types
=============

[Language: Defined Resource Types](https://docs.puppetlabs.com/puppet/latest/reference/lang_defined_types.html)
[Learning Puppet - Defined Types](https://docs.puppetlabs.com/learning/definedtypes.html)

Defined types allow you to execute a code in the same way as a class, however multiple times (classes can only be called/executed once).

Let's say you are defining multiple virtual host entries for your web server and you need to call the class `apache::vhost` multiple times in your `init.pp`. You **CANNOT** do this:

```puppet
include apache::vhost 
include apache::vhost 
```

So your option is to define your `apache::vhost`, as you would a class:

```puppet
define apache::vhost (
    $port, 
    $document_root, 
    $servername, 
    $vhost_name = '*', 
    $vhost_dir
) {

...
}
```

And then call multiple instance of the defined type in `init.pp` for that module:

```puppet
apache::vhost { "default":
    port          => 80,
    document_root => $document_root,
    servername    => $servername,
    vhost_dir     => $vhost_dir,
}

apache::vhost { "site1":
    port          => 80,
    document_root => $document_root,
    servername    => $servername,
    vhost_dir     => $vhost_dir,
}
```

#### The catch

You will need to make sure that the resource types in the defined type have different names. 

For example, let's say you have the following in the defined type `welcome.pp`:

```puppet
define base::welcome ($user = $tittle, $content) {
    file { 'welcome_file':
        path    => "/home/${user}/welscome.txt",
        ensure  => file,
        content => $content,
    }
}
```

And you call it for two users in `init.pp`:

```puppet
base::welcome { 'victor':
    content => "Welcome Victor"
}

base::welcome { 'john':
    content => "Welcome John"
}
```

This will fail because essentially you are calling the resource type `file { 'welcome_file':` twice. 

The fix would be:

```puppet
define base::welcome ($user = $tittle, $content) {

    file { $user:
        path    => "/home/${user}/welcome.txt",
        ensure  => file,
        content => $content,
    }
}
```