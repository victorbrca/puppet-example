# Node Deactivation (Puppet enterprise)

**Steps:**
- Stop agent on node
- Deactivate the node on master (removes from DB and frees up the license) - `pupped node deactivate [cert]`
- Revoke the node cert on master - `puppet cert clean [cert]`
- Restart the puppet master
- Delete the node on the console
- Stop the mcollective service on node
- Remove the mcollective certificates from the node - `rm -f /etc/puppetlabs/mcollective/ssl/client`