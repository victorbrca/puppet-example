Installing Puppet
=================


Installing Puppet Enterprise
----------------------------

[Installing Puppet Enterprise Overview](https://docs.puppetlabs.com/pe/latest/install_basic.html)

### Master

Enable root login.

```bash
PermitRootLogin yes
service sshd restart
```

Setup FQDN on Puppet master.

```bash
cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
127.0.1.1   puppetmaster.mydomain.com
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

Download puppet-enterprise from puppet labs (http://puppetlabs.com/download-puppet-enterprise-thank-you-all) and extract it.

```bash
tar -xzvf puppet-enterprise-3.7.1-el-7-x86_64.tar.gz
```

Make sure the installer is executable and run it.

```bash
cd puppet-enterprise-3.7.1-el-7-x86_64
chmod u+x puppet-enterprise-installer 
./puppet-enterprise-installer
```
You can also use an answer file with:

- Create an answer file or obtain the answer file created by the web-based installer. You can find the latter at /opt/puppet/share/installer/answers on the machine from which you ran the installer.
- Run the installer with the -a or -A flag pointed at the answer file.

Type in a 'y' at the prompt.

```
STEP 1: GUIDED INSTALLATION

Before you begin, choose an installation method. We've provided a few paths to choose from.

- Perform a guided installation using the web-based interface. Think of this as an installation interview in which we ask you exactly how you want to install PE. In order to use the web-based installer, you
must be able to access this machine on port 3000 and provide the SSH credentials of a user with root access. This method will login to servers on your behalf, install Puppet Enterprise and get you up and
running fairly quickly.

- Use the web-based interface to create an answer file so that you login to the servers yourself and perform the installation locally. Refer to Automated Installation with an Answer File
(http://docs.puppetlabs.com/pe/3.3/install_automated.html), which provides an overview on installing PE with an answer file.

- If you choose not to use the web-based interface, you can write your own answer file or use the answer file(s) provided in the PE installation tarball. Check the Answer File Reference Overview
(http://docs.puppetlabs.com/pe/3.3/install_answer_file_reference.html) to get started.

Install packages and perform a guided install? [Y/n]
```

Open the URL given with your browser to continue with the installation.

```
Please go to https://puppetmaster.mydomain.com:3000 in your browser to continue installation. Be sure to use https:// and that port 3000 is reachable through the firewall.
```

- Click on "Let's get started"

- Select the type (choose Monolithic if you don't know)

- Enter the FQDN of the server

- Enter the password for root

- Make sure "Install PostgreSQL for me" is selected

- Enter the superuser email address and password for the console administrator user

- Use 'localhost' as SMTP hostname (or use your own settings if you know how)

- Click "Submit"

- Review the options and click on "Continue"

- If you are installing this on a lab/test server, you may get warnings due to hardware not meeting the requirements. Ignore that and click on "Deploy now"

- Click on "Start using Puppet Enterprise"

### Node

Enable root login

```bash
PermitRootLogin yes
service sshd restart
```

**Install puppet pe (missing this section)**


Configure node to connect to master by setting up 'server' in pupppet.conf on node

Check if can connect to master by running `puppet agent` (this also runs all catalogs if cert has already been added on the master, or if the option `autosign` is enabled on the master)

```
puppet agent -t
```

Check on master nodes waiting for key

```
puppet cert list
```

Sign node from master

```
puppet cert sign puppetnode.mydomain.ca
```

Or sign all nodes

```
puppet cert sign --all
```

Run `puppet agent` on node again, or wait for next run time (dictated by option `runinterval` on agent)

```
puppet agent -t
```

Installing Puppet Open Source
----------------------------
