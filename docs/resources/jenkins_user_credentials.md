---
title: About the jenkins_user_credentials Resource
platform: os
---

# jenkins_user_credentials

Use the `jenkins_user_credentials` InSpec resource to test a Jenkins User Credentials for:
- its existance
- its description
- it has a private key
- it has a passphrase

<br>

## Syntax

A `jenkins_user_credentials` resource block declares a secret name and then one (or more) matchers:

```ruby
  describe jenkins_user_credentials('demo_user') do
    it { should exist }
    its('description') { should eq 'Some description' }
    it { should have_private_key }
    it { should have_passphrase }
  end
```

where

* `('demo_user')` is the user to be tested
* `it { should exist }` tests if the `Jenkins User Credentials` exists
* `its('description')` tests if the description is set correctly
* `it { should have_private_key }` - returns that the credentials have a private key
* `it { should have_passphrase }` - returns that the credentials have a passphrase

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify a Jenkins User Credentials exist

```ruby
  describe jenkins_user_credentials('demo_user') do
    it { should exist }
    it { should have_private_key }
    it { should have_passphrase }
  end
```

### Verify a Jenkins User Credentials has a description

```ruby
  describe jenkins_user_credentials('demo_user') do
    it { should exist }
    its('description') { should eq 'Some Description') }
  end
```

## Matchers

### exist

The `exist` matcher tests if the `Jenkins User Credentials` exists:

```ruby
    it { should exist }
```

### description

The `description` matcher tests the description for the `Jenkins User Credentials`:

```ruby
    its('description') { should eq 'Some description' }
```

### have_password

The `have_password?` matcher tests if the `Jenkins User Credentials` has a password:

```ruby
    it { should have_password }
```

### have_private_key

The `have_private_key?` matcher tests if the `Jenkins User Credentials` has a private key:

```ruby
    it { should have_private_key }
```

### have_passphrase

The `have_passphrase?` matcher tests if the `Jenkins User Credentials` has a passphrase:

```ruby
    it { should have_passphrase }
```
