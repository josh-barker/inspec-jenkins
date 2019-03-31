---
title: About the jenkins_proxy Resource
platform: os
---

# user

Use the `jenkins_proxy` InSpec resource to test the Jenkins Proxy configuration for:
- its existance
- its name
- its port
- its noproxy

<br>

## Syntax

A `jenkins_proxy` resource block declares a proxy name and then one (or more) matchers:

```ruby
  describe jenkins_proxy('5.6.7.8:9012') do
    it { should exist }
    its('name') { should eq '5.6.7.8' }
    its('port') { should eq 9012 }
    its('noproxy') { should include 'nohost' }
    its('noproxy') { should include '*.nodomain' }
  end
```

where

* `(''5.6.7.8:9012')` is `'5.6.7.8:9012` to be tested
* `it { should exist }` tests if the jenkins proxy exists
* `its('name')` - returns the hostname or ip for the proxy
* `its('port')` - returns the port for the proxy
* `its('noproxy')` - returns the array of exclusions for the proxy

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify a Jenkins Proxy is configured

```ruby
  describe jenkins_proxy('5.6.7.8:9012') do
    it { should exist }
    its('name') { should eq '5.6.7.8' }
    its('port') { should eq 9012 }
    its('noproxy') { should eq(['nohost', '*.nodomain']) }
  end
```

## Matchers

### exist

The `exist` matcher tests if the jenkins plugin exists:

```ruby
    it { should exist }
```

### name

The `name` matcher tests if the `Jenkins Proxy` has the IP address or hostname:

```ruby
    its('name') { should eq '5.6.7.8' }
```

### port

The `port` matcher tests if the `Jenkins Proxy` is port:

```ruby
    its('port') { should eq 9012 }
```

### noproxy

The `noproxy` matcher tests the noproxy for the `Jenkins Proxy`:

```ruby
    its('noproxy') { should include 'nohost' }
    its('noproxy') { should include '*.nodomain' }
```