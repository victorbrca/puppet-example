# Site.pp

The include function declares a class, if it hasn’t already been declared somewhere else. If a class HAS already been declared, include will notice that and do nothing.

Usually the order of include is not important due to require and dependencies.



node name can consist of Regex (without double quotes)

Matches:
node1.mydomain.com
node2.mydomain.com
...

/^node\d{1}.mydomain.com$/