---
title: About the jenkins_user Resource
platform: os
---

# jenkins_user

Use the `jenkins_user` InSpec resource to test a Jenkins User for:
- its existance
- its email
- its full_name
- its public_keys
- its password_hash

<br>

## Syntax

A `jenkins_user` resource block declares a secret name and then one (or more) matchers:

```ruby
  describe jenkins_user('dave') do
    it { should exist }
    its('full_name') { should eq('Dave Smith') }
    its('email') { should eq('someuser@somewhere.io') }
    its('public_keys') { should include('ssh-rsa AAAAAAA') }
    its('password_hash') { should include('XXX') }
  end
```

where

* `('dave')` is the user to be tested
* `it { should exist }` tests if the `Jenkins User` exists
* `its('full_name')` tests if the full name is set correctly
* `its('email')` tests if the email is set correctly
* `its('public_keys')` tests if the public keys are set correctly
* `its('password_hash')` tests if the password hash is set correctly

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify a Jenkins User exists

```ruby
  describe jenkins_user('dave') do
    it { should exist }
    its('full_name') { should eq('Dave Smith') }
  end
```

### Verify a Jenkins User has the correct public keys


```ruby
  describe jenkins_user('dave') do
    it { should exist }
    its('public_keys') { should include('ssh-rsa AAAAAAA') }
    its('public_keys') { should include('ssh-rsa BBBBBBB') }
  end
```

## Matchers

### exist

The `exist` matcher tests if the `Jenkins User` exists:

```ruby
    it { should exist }
```

### email

The `email` matcher tests the email for the `Jenkins User`:

```ruby
    its('email') { should eq 'abc@abc.com' }
```

### full_name

The `full_name` matcher tests the full_name for the `Jenkins User`:

```ruby
    its('full_name') { should eq 'Dave Smith' }
```

### public_keys

The `public_keys` matcher tests the public keys for the `Jenkins User`:

```ruby
    its('public_keys') { should include('ssh-rsa AAAAAAA') }
```

### password_hash

The `password_hash` matcher tests the password hash for the `Jenkins User`:

```ruby
    its('password_hash') { should eq 'XXX' }
```