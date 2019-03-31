---
title: About the jenkins_plugin Resource
platform: os
---

# jenkins_plugin

Use the `jenkins_plugin` InSpec resource to test a Jenkins Plugin for:
- its existance
- if its enabled or disabled
- the version

<br>

## Syntax

A `jenkins_plugin` resource block declares a plugin name and then one (or more) matchers:

```ruby
  describe jenkins_plugin('disk-usage') do
    it { should exist }
    it { should be_enabled }
    its('version') { should eq '0.23' }
  end
```

where

* `('disk-usage')` is `disk-usage` to be tested
* `it { should exist }` tests if the jenkins plugin exists
* `be_enabled` - returns if the plugin is enabled
* `version` - returns the version for the plugin

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify a Jenkins Plugin is enabled

```ruby
  describe jenkins_plugin('disk-usage') do
    it { should exist }
    it { should be_enabled }
    its('version') { should eq '0.23' }
  end
```

### Verify a Jenkins Plugin is disabled

```ruby
  describe jenkins_plugin('ansicolor') do
    it { should exist }
    it { should be_disabled }
  end
```

## Matchers

### exist

The `exist` matcher tests if the jenkins plugin exists:

```ruby
    it { should exist }
```

### enabled

The `enabled` matcher tests if the `jenkins plugin` is enabled:

```ruby
    it { should be_enabled }
```

### disabled

The `disabled` matcher tests if the `jenkins plugin` is disabled:

```ruby
    it { should be_disabled }
```

### version

The `version` matcher tests the version for the specific plugin:

```ruby
    its('version') { should eq '0.23' }
```