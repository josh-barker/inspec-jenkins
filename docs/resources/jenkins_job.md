---
title: About the jenkins_job Resource
platform: os
---

# jenkins_job

Use the `jenkins_job` InSpec resource to test a Jenkins Job for:
- its existance
- if its enabled or disabled
- the command
- the plugin

<br>

## Syntax

A `jenkins_job` resource block declares a job name and then one (or more) matchers:

```ruby
  describe jenkins_job('enabled-job') do
    it { should exist }
    it { should be_enabled }
    it { should_not be_disabled }
    its('command') { should eq 'echo "This is Jenkins! Hear me roar!"' }
  end
```

where

* `('enabled-job')` is `enabled-job` to be tested
* `it { should exist }` tests if the jenkins job exists
* `be_enabled` - returns if the job is enabled
* `be_disabled` - returns if the job is disabled
* `command` - returns the job command

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify a Jenkins Job is enabled

```ruby
  describe jenkins_job('enabled-job') do
    it { should exist }
    it { should be_enabled }
  end
```

### Verify a Jenkins Job is disabled

```ruby
  describe jenkins_job('disabled-job') do
    it { should exist }
    it { should be_disabled }
  end
```

### Verify a Jenkins Job's command is set

```ruby
  describe jenkins_job('job-command') do
    it { should exist }
    its('command') { should eq 'whoami' }
  end
```

### A folder called my-folder should exist

```ruby
  describe jenkins_job('my-folder') do
    it { should exist }
    its('plugin') { should match(/^cloudbees-folder/) }
  end
```

## Matchers

### exist

The `exist` matcher tests if the jenkins job exists:
```ruby
    it { should exist }
```

### enabled

The `enabled` matcher tests if the `jenkins job` is enabled:
```ruby
    it { should be_enabled }
```

### disabled

The `disabled` matcher tests if the `jenkins job` is disabled:
```ruby
    it { should be_disabled }
```

### command

The `command` matcher tests if the `jenkins job` command is set:
```ruby
    its('command') { should eq 'whoami' }
```

### plugin

The `plugin` matcher tests the plugin for the specific job:
```ruby
    its('plugin') { should match(/^cloudbees-folder/) }
```