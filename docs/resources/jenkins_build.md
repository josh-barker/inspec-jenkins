---
title: About the jenkins_build Resource
platform: os
---

# jenkins_build

Use the `jenkins_build` InSpec resource to test a Jenkins Job's Build for:
- its existance
- its result
- the parameters passed to it

<br>

## Syntax

A `jenkins_build` resource block declares a job name, a build identifier, and then one (or more) matchers:

```ruby
    describe jenkins_build('simple-execute', 1) do
      it { should exist }
      its('result') { should eq 'SUCCESS' }
      its('parameters') { should eq({"BOOLEAN_PARAM" => true, "STRING_PARAM" => "meeseeks"}) }
    end
```

where

* `('simple-execute', 1)` is build `1` for `simple-execute` to be tested
* `it { should exist }` tests if the jenkins build exists
* `result` - returns the result of the build
* `parameters` - returns a Hash of parameters

Note: The build identifier can also be one of:
- `'lastCompletedBuild'`
- `'lastStableBuild'`
- `'lastSuccessfulBuild'`
- `'lastFailedBuild'`
- `'lastUnsuccessfulBuild'`

<br>

## Examples

The following examples show how to use this InSpec resource.

### Verify the first build was a success for the `simple-execute` job

```ruby
  describe jenkins_build('simple-execute', 1) do
    it { should exist }
    its('result') { should eq 'SUCCESS' }
  end
```

### Verify the build 99 does not exist for the `simple-execute` job

```ruby
  describe jenkins_build('simple-execute', 99) do
    it { should_not exist }
  end
```

### Verify the last build (`'lastBuild'`) was a success for the `simple-execute` job

```ruby
  describe jenkins_build('simple-execute', 'lastBuild') do
    it { should exist }
    its('result') { should eq 'SUCCESS' }
  end
```

## Matchers

### exist

The `exist` matcher tests if the jenkins build exists:
```ruby
    it { should exist }
```

### result

The `result` matcher tests the result of the `jenkins build`:
```ruby
    its('result') { should eq 'SUCCESS' }
```

### parameters

The `parameters` matcher tests the parameters for the specific job:
```ruby
    its('parameters') { should eq({"BOOLEAN_PARAM" => true}) }
```