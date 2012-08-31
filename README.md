# Puppet module for Riak

This module allows you to manage Riak with puppet.

Riak is a Dynamo-inspired key/value store that scales predictably and easily.  Riak combines a decentralized key/value store, a flexible map/reduce engine, and a friendly HTTP/JSON query interface to provide a database ideally suited for Web applications. And, without any object-relational mappers and other heavy middleware, applications built on Riak can be both simpler and more powerful.  For complete documentation and source code, see the Riak home page at [Basho][1].

## Getting Started

Requires a 64-bit operating system, tested on Puppet 2.7.17 and 3.0-rc5. Requires a basic configuration of Hiera.

#### Adding the module

First clone the module,

```
$ git clone git://github.com/haf/puppet-riak.git /etc/puppet/modules/riak
```

Make sure you are shipping the custom functions in this module to your i
nodes, by setting pluginsync=true;

```
[main]
    pluginsync = true
```

### Basic Installation

This will install Riak using all of the defaults:

```
class { 'riak': }
```

or

```
include riak
```

### Tested on:

 * Ubuntu 12.04 64-bit
 * Debian 6.0 64-bit
 * CentOs 6.0 64-bit

## Development Environment

You can simply clone this module like normal to your puppet-modules-folder. 
It'll work. Done.

If you want to check that it works, then install `vagrant`, `rake` and 
`VirtualBox`, then run `rake vagrant:up`.

----

With that out of the world. Here's how to set up the full chaboom:

 1. `git clone https://github.com/haf/puppet-riak.git`
 1. `cd puppet-riak`
 1. Install RVM and bundler. `curl -L https://get.rvm.io | bash -s stable --ruby --gems=bundler,rubygems-bundler`
 1. `rvm requirements`: follow these instructions. I'm using RMI 1.9.3.
 1. `bundle install`
 1. `gem regenerate_binstubs`
 1. `rake vagrant:up`

So what have you got now? By installing all required gems with bundler, you 
now have a complete development environment for testing puppet modules and 
manifests, including autotesting them when you change the source files.

When running `vagrant up`, you started three virtual machines that were
provisioned to run Riak, and connect all three of them together. This is 
your lab environment. You can make the `Guardfile` provision all machines
any time you change a puppet (.pp) file.

If you have ubuntu, you can start writing tests/manifests. Start the watcher
by running `guard`. Edit a spec file and watch how it runs. If you don't have
ubuntu, then look at your options at 
[guard/guard](https://github.com/guard/guard#readme).

Henrik.

### References

 * http://www.slideshare.net/PuppetLabs/modern-module-development-ken-barber-2012-edinburgh-puppet-camp
 * http://www.slideshare.net/Alvagante/puppet-modules-an-holistic-approach
 * http://puppetlabs.com/blog/puppet-module-bounty-logstash-riak-and-graphite/?utm_campaign=blog&utm_medium=socnet&utm_source=twitter&utm_content=modbounty1
 * http://puppetlabs.com/blog/the-next-generation-of-puppet-module-testing/

### Outstanding External Issues

 * https://github.com/gposton/vagrant-hiera/issues/2

   This issue surfaces every time PuppetLabs releases a new version of their
   puppet deb, because then the old one doesn't install properly anymore.

 * https://github.com/rodjek/rspec-puppet/issues/44

   This issue affects the tests, making them impossible to run cleanly
   together at the moment. The only way around it, is to launch rspec
   first for `classes`, then for `functions`.

 * https://github.com/rubyist/guard-rake/issues/12

   This issue is solved by Joerg, but he hasn't submitted a pull request,
   so I've cloned his repository and am using my own clone of that, until
   the issue is resolved (about 4 lines of code) in master. Affects
   running of rake when the task raises errors.

 * http://projects.puppetlabs.com/issues/15820

   This issue is what is currently failing all of `spec/classes/`. A fix
   HAS been released, but not as a gem. The repository doesn't allow me
   to report issues conveniently, and there's no gemspec file, so I can't
   just reference the repo either.

 * https://github.com/amfranz/rspec-hiera-puppet/issues/3

   This issue affects a single test that exposed the issue; overriding
   puppet variables with rspec variables. The test is currently marked as
   pending.

#### Example42

From your excellent presentations I could find online, and your samples
at your github. Thanks Alessandro.

[1]: http://basho.com/
