---
title: About the jenkins_secret_text_credentials Resource
platform: os
---

# jenkins_secret_text_credentials

Use the `jenkins_secret_text_credentials` InSpec resource to test a Secret Text Credential in Jenkins for:
- its existance
- it has a secret

<br>

## Syntax

A `jenkins_secret_text_credentials` resource block declares a secret name and then one (or more) matchers:

```ruby
  describe jenkins_secret_text_credentials('dollarbills_secret') do
    it { should exist }
    it { should have_secret? }
  end
```

where

* `('dollarbills_secret')` is `'dollarbills_secret` to be tested
* `it { should exist }` tests if the jenkins proxy exists
* `it { should have_secret? }` - returns that the credentials has a secret

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify a Jenkins Credentials exist

```ruby
  describe jenkins_secret_text_credentials('dollarbills_secret') do
    it { should exist }
    it { should have_secret? }
  end
```

## Matchers

### exist

The `exist` matcher tests if the jenkins plugin exists:

```ruby
    it { should exist }
```

### have_secret

The `have_secret` matcher tests if the `Jenkins Secret Text Credentials` has a secret:

```ruby
    it { should have_secret? }
```