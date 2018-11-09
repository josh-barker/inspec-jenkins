require 'spec_helper'

require_relative '../../libraries/jenkins_slave'

describe JenkinsSlave do
  let(:subject) { described_class.new(slave_name) }

  let(:root_dir) { Dir.pwd }
  let(:slave_file) { File.join(root_dir, 'spec', 'mock', 'jenkins_slave', 'file', "#{slave_name}.xml") }
  let(:slave_file_content) { IO.read(slave_file) }

  let(:xml_response_file) { File.join(root_dir, 'spec', 'mock', 'jenkins_slave', 'http', 'by_xml_format', "#{slave_name}.json") }
  let(:json_response_file) { File.join(root_dir, 'spec', 'mock', 'jenkins_slave', 'http', 'by_json_format', "#{slave_name}.json") }

  let(:credential_file_content) { IO.read(File.join(root_dir, 'spec', 'mock', 'jenkins_credentials', 'credentials.xml')) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)

    xml_http = OpenStruct.new(JSON.parse(IO.read(xml_response_file), symbolize_names: true))
    allow_any_instance_of(described_class).to receive(:rest_call).with('GET', "http://localhost:8080/computer/#{slave_name}/config.xml", {}).and_return(xml_http)

    json_http = OpenStruct.new(JSON.parse(IO.read(json_response_file), symbolize_names: true))
    allow_any_instance_of(described_class).to receive(:rest_call).with('GET', "http://localhost:8080/computer/#{slave_name}/api/json?pretty=true", {}).and_return(json_http)

    stub_inspec_file("/var/lib/jenkins/credentials.xml", :file? => true, content: credential_file_content)
  end

  context 'jnlp-builder' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    let(:slave_name) { 'jnlp-builder' }

    it 'name is jnlp-builder' do
      expect(subject.name).to eq 'jnlp-builder'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is true' do
      expect(subject.connected?).to eq true
    end

    it 'online? is true' do
      expect(subject.online?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq "A generic slave builder"
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/tmp/jenkins/slaves/builder'
    end

    it 'labels are set' do
      expect(subject.labels).to eq ['builder', 'linux']
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'exclusive'
    end

    it 'availability is NoOp' do
      expect(subject.availability).to eq "NoOp"
    end

    it 'in_demand_delay is 0' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 0' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is nil' do
      expect(subject.host).to eq nil
    end

    it 'port is nil' do
      expect(subject.port).to eq nil
    end

    it 'java_path is nil' do
      expect(subject.java_path).to eq nil
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to be_nil
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to be_nil
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to be_nil
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to be_nil
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to be_nil
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq ''
    end
  end

  context 'jnlp-executor' do
    let(:slave_name) { 'jnlp-executor' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    it 'name is jnlp-executor' do
      expect(subject.name).to eq 'jnlp-executor'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is true' do
      expect(subject.connected?).to eq true
    end

    it 'online? is true' do
      expect(subject.online?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq "Run test suites"
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/tmp/jenkins/slaves/executor'
    end

    it 'labels are set' do
      expect(subject.labels).to eq ["executor", "freebsd", "jail"]
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'exclusive'
    end

    it 'availability is NoOp' do
      expect(subject.availability).to eq "NoOp"
    end

    it 'in_demand_delay is 0' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 0' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({"BAZ"=>"qux", "FOO"=>"bar"})
    end

    it 'host is nil' do
      expect(subject.host).to eq nil
    end

    it 'port is nil' do
      expect(subject.port).to eq nil
    end

    it 'java_path is nil' do
      expect(subject.java_path).to eq nil
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to be_nil
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to be_nil
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to be_nil
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to be_nil
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to be_nil
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq ''
    end
  end

  context 'jnlp-smoke' do
    let(:slave_name) { 'jnlp-smoke' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    it 'name is jnlp-smoke' do
      expect(subject.name).to eq 'jnlp-smoke'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is true' do
      expect(subject.connected?).to eq true
    end

    it 'online? is true' do
      expect(subject.online?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq "Run high-level integration tests"
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/tmp/jenkins/slaves/smoke'
    end

    it 'labels are set' do
      expect(subject.labels).to eq ["fast", "runner"]
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'exclusive'
    end

    it 'availability is Demand' do
      expect(subject.availability).to eq "Demand"
    end

    it 'in_demand_delay is 1' do
      expect(subject.in_demand_delay).to eq 1
    end

    it 'idle_delay is 3' do
      expect(subject.idle_delay).to eq 3
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is nil' do
      expect(subject.host).to eq nil
    end

    it 'port is nil' do
      expect(subject.port).to eq nil
    end

    it 'java_path is nil' do
      expect(subject.java_path).to eq nil
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to be_nil
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to be_nil
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to be_nil
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to be_nil
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to be_nil
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq ''
    end
  end

  context 'missing' do
    let(:slave_name) { 'missing' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => false)
    end

    it 'name is missing' do
      expect(subject.name).to eq 'missing'
    end

    it 'exist? is false' do
      expect(subject.exist?).to eq false
    end

    it 'connected? is false' do
      expect(subject.connected?).to eq false
    end

    it 'online? is false' do
      expect(subject.online?).to eq false
    end

    it 'description is set' do
      expect(subject.description).to be_nil
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to be_nil
    end

    it 'labels are set' do
      expect(subject.labels).to eq []
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to be_nil
    end

    it 'availability is Demand' do
      expect(subject.availability).to be_nil
    end

    it 'in_demand_delay is 1' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 3' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is nil' do
      expect(subject.host).to eq nil
    end

    it 'port is nil' do
      expect(subject.port).to eq nil
    end

    it 'java_path is nil' do
      expect(subject.java_path).to eq nil
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to be_nil
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to be_nil
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to be_nil
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to be_nil
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to be_nil
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to be_nil
    end
  end

  context 'ssh-builder' do
    let(:slave_name) { 'ssh-builder' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    it 'name is ssh-builder' do
      expect(subject.name).to eq 'ssh-builder'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is true' do
      expect(subject.connected?).to eq true
    end

    it 'online? is true' do
      expect(subject.online?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'A builder, but over SSH'
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/tmp/slave-ssh-builder'
    end

    it 'labels are set' do
      expect(subject.labels).to eq ['builder', 'linux']
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'normal'
    end

    it 'availability is Demand' do
      expect(subject.availability).to eq 'NoOp'
    end

    it 'in_demand_delay is 1' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 3' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is localhost' do
      expect(subject.host).to eq 'localhost'
    end

    it 'port is 22' do
      expect(subject.port).to eq 22
    end

    it 'java_path is set' do
      expect(subject.java_path).to eq '/usr/bin/java'
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to eq '38537014-ec66-49b5-aff2-aed1c19e2989'
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to eq 'jenkins-ssh-key'
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to eq 120
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to eq 5
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to eq 60
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq ''
    end
  end

  context 'ssh-executor' do
    let(:slave_name) { 'ssh-executor' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    it 'name is ssh-executor' do
      expect(subject.name).to eq 'ssh-executor'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is true' do
      expect(subject.connected?).to eq true
    end

    it 'online? is true' do
      expect(subject.online?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'An executor, but over SSH'
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/tmp/slave-ssh-executor'
    end

    it 'labels are set' do
      expect(subject.labels).to eq ["executor", "freebsd", "jail"]
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'normal'
    end

    it 'availability is Demand' do
      expect(subject.availability).to eq 'NoOp'
    end

    it 'in_demand_delay is 1' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 3' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is localhost' do
      expect(subject.host).to eq 'localhost'
    end

    it 'port is 22' do
      expect(subject.port).to eq 22
    end

    it 'java_path is set' do
      expect(subject.java_path).to be_nil 
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to eq '38537014-ec66-49b5-aff2-aed1c19e2989'
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to eq 'jenkins-ssh-key'
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to eq 120
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to eq 5
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to eq 60
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq ''
    end
  end

  context 'ssh-smoke' do
    let(:slave_name) { 'ssh-smoke' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    it 'name is ssh-smoke' do
      expect(subject.name).to eq 'ssh-smoke'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is true' do
      expect(subject.connected?).to eq true
    end

    it 'online? is true' do
      expect(subject.online?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'A smoke tester, but over SSH'
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/home/jenkins-ssh-password'
    end

    it 'labels are set' do
      expect(subject.labels).to eq ["fast", "runner"]
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'normal'
    end

    it 'availability is Demand' do
      expect(subject.availability).to eq 'NoOp'
    end

    it 'in_demand_delay is 1' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 3' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is localhost' do
      expect(subject.host).to eq 'localhost'
    end

    it 'port is 22' do
      expect(subject.port).to eq 22
    end

    it 'java_path is set' do
      expect(subject.java_path).to be_nil 
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to eq 'jenkins-ssh-password'
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to eq 'jenkins-ssh-password'
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to eq 120
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to eq 5
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to eq 60
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq ''
    end
  end

  context 'ssh-to-offline' do
    let(:slave_name) { 'ssh-to-offline' }

    before(:each) do
      stub_inspec_file("/var/lib/jenkins/nodes/#{slave_name}/config.xml", :file? => true, content: slave_file_content)
    end

    it 'name is ssh-to-offline' do
      expect(subject.name).to eq 'ssh-to-offline'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'connected? is false' do
      expect(subject.connected?).to eq false
    end

    it 'online? is false' do
      expect(subject.online?).to eq false
    end

    it 'description is set' do
      expect(subject.description).to eq 'Jenkins slave ssh-to-offline'
    end

    it 'remote_fs is set' do
      expect(subject.remote_fs).to eq '/tmp/ssh-to-offline'
    end

    it 'labels are set' do
      expect(subject.labels).to eq []
    end

    it 'usage_mode is true' do
      expect(subject.usage_mode).to eq 'normal'
    end

    it 'availability is Demand' do
      expect(subject.availability).to eq 'NoOp'
    end

    it 'in_demand_delay is 1' do
      expect(subject.in_demand_delay).to eq 0
    end

    it 'idle_delay is 3' do
      expect(subject.idle_delay).to eq 0
    end

    it 'environment is true' do
      expect(subject.environment).to eq({})
    end

    it 'host is localhost' do
      expect(subject.host).to eq 'localhost'
    end

    it 'port is 22' do
      expect(subject.port).to eq 22
    end

    it 'java_path is set' do
      expect(subject.java_path).to be_nil 
    end

    it 'credentials id is set' do
      expect(subject.credentials_id).to eq 'jenkins-ssh-password'
    end

    it 'credentials username is set' do
      expect(subject.credentials_username).to eq 'jenkins-ssh-password'
    end

    it 'launch timeout is set' do
      expect(subject.launch_timeout).to eq 120
    end

    it 'ssh retries is set' do
      expect(subject.ssh_retries).to eq 5
    end

    it 'ssh wait retries is 60' do
      expect(subject.ssh_wait_retries).to eq 60
    end

    it 'offline reason is set' do
      expect(subject.offline_reason).to eq 'Autobots ran out of energy'
    end
  end
end
