Site.pp
========

[Node Definitions](https://docs.puppetlabs.com/puppet/latest/reference/lang_node_definitions.html)

[A More Advanced Puppet Pattern](http://projects.puppetlabs.com/projects/1/wiki/advanced_puppet_pattern)

### Node Definition

- Every node definition must have a class within it
- Default node definition allows for a "fallback" in case there's no match to other note definitions
- Node name can consist of regex (without double quotes)
- If a node matches multiple node definitions via regex, puppet will arbitrary use one of the definitions  

**Node Matching Order**
- Exact matches
- Regex
- FQDN
    - It will remove the last group from the FQDN and try to match "server01.mydomain" (without top level domain ".com")
    - It will remove group two and match against the hostname "server01"
- Default node


Example Regex

```puppet
# Matches:
# node1.mydomain.com
# node2.mydomain.com
# etc

/^node\d{1}.mydomain.com$/
```

## ENC - External Node Classifiers

An external node classifier is an executable that can be called by puppet master; it doesn’t have to be written in Ruby. Its only argument is the name of the node to be classified, and it returns a YAML document describing the node.

Inside the ENC, you can reference any data source you want, including some of Puppet’s own data sources, but from Puppet’s perspective, it just puts in a node name and gets back a hash of information.


#### Using both site.pp and External Node Classifier

- If using both, site.pp must have a node definition (like default)
- Classes declared in each source are effectively merged