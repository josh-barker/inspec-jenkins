# inspec-jenkins

[![CircleCI](https://circleci.com/gh/josh-barker/inspec-jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/josh-barker/inspec-jenkins/tree/master) [![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

This project contains [InSpec](https://inspec.io) Resouces for testing [Jenkins](https://jenkins.com)

## Resources

### jenkins_build

Example:

```ruby
control 'jenkins_job-example' do
  impact 0.7
  title 'Jenkins Job with parameters is created'

  describe jenkins_build('some-job-with-params', 'lastSuccessfulBuild') do
    it { should exist }
    it 'was executed with the correct parameters' do
      expect(subject.parameters).to include(
        'STRING_PARAM' => 'some value',
        'BOOLEAN_PARAM' => true
      )
    end
  end
end
```

### jenkins_job

Example:

```ruby
control 'jenkins_job-example' do
  impact 0.7
  title 'Jenkins Job is created'

  describe jenkins_job('some-job') do
    it { should exist }
    its('command') { should eq 'some command' }
  end
end
```

### jenkins_plugin

Example:

```ruby
control 'jenkins_plugin-example' do
  impact 0.7
  title 'jenkins Plugins are installed'

  describe jenkins_plugin('disk-usage') do
    it { should exist }
    its('version') { should eq '0.23' }
  end
end
```

### jenkins_proxy

Example:

```ruby
control 'jenkins_proxy-example' do
  impact 0.7
  title 'Jenkins Proxy is configured'

  describe jenkins_proxy('5.6.7.8:9012') do
    it { should exist }
    its('name') { should eq '5.6.7.8' }
    its('port') { should eq 9012 }
    its('noproxy') { should include 'nohost' }
    its('noproxy') { should include '*.nodomain' }
  end
end
```

### jenkins_secret_text_credentials

Example:

```ruby
control 'jenkins_secret_text_credentials-example' do
  impact 0.7
  title 'Jenkins Secret Text Credential is created'

  describe jenkins_secret_text_credentials('some-secret-text') do
    it { should exist }
    it { should have_secret }
  end
end
```

### jenkins_slave

Example:

```ruby
control 'jenkins_slave-example' do
  impact 0.7
  title 'Jenkins SSH Slave is created and configured'

  describe jenkins_slave('some-ssh-slave') do
    it { should exist }
    its('description') { should eq 'Some description' }
    its('remote_fs') { should eq '/tmp/some-ssh-slave' }
    its('labels') { should eq %w(some-ssh-slave linux) }
    its('host') { should eq 'localhost' }
    its('port') { should eq 22 }
    its('credentials_id') { should eq '12345678-abcd-efef-1234-56789abcdef1' }
    its('credentials_username') { should eq 'jenkins-ssh-key' }
    its('java_path') { should eq '/usr/bin/java' }
    its('launch_timeout') { should eq 120 }
    its('ssh_retries') { should eq 5 }
    its('ssh_wait_retries') { should eq 60 }
    it { should be_connected }
    it { should be_online }
  end
end
```

### jenkins_user_credentials

Example:

```ruby
control 'jenkins_credentials-example' do
  impact 0.7
  title 'Jenkins Users are created'

  describe jenkins_user_credentials('some-user') do
    it { should exist }
    its('id') { should eq 'some-user' }
    its('description') { should eq 'some description' }
    it { should have_password }
  end
end
```

### jenkins_user

Example:

```ruby
control 'jenkins_user-example' do
  impact 0.7
  title 'Jenkins User are created'

  describe jenkins_user('some-user') do
    it { should exist }
    its('full_name') { should eq('Some User') }
    its('email') { should eq('someuser@somewhere.io') }
    its('public_keys') { should include('ssh-rsa AAAAAAA') }
  end
end
```