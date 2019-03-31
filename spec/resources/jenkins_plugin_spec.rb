require 'spec_helper'

require_relative '../../libraries/jenkins_plugin'

describe JenkinsPlugin do
  let(:subject) { described_class.new(plugin_name) }

  let(:job_file) { File.join(Dir.pwd, 'spec', 'mock', 'jenkins_plugin', "#{plugin_name}-MANIFEST.MF") }
  let(:job_file_content) { IO.read(job_file) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)
  end

  context 'credentials plugin' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}/META-INF/MANIFEST.MF", :file? => true, content: job_file_content)
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}.jpi.disabled", :file? => false)
    end

    let(:plugin_name) { 'credentials' }
    
    it 'name is credentials' do
      expect(subject.name).to eq 'credentials'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'enabled? is true' do
      expect(subject.enabled?).to eq true
    end

    it 'disabled? is false' do
      expect(subject.disabled?).to eq false
    end

    it 'version' do
      expect(subject.version).to eq '2.1.16'
    end
  end

  context 'ssh-slaves plugin' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}/META-INF/MANIFEST.MF", :file? => true, content: job_file_content)
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}.jpi.disabled", :file? => false)
    end

    let(:plugin_name) { 'ssh-slaves' }
    
    it 'name is ssh-slaves' do
      expect(subject.name).to eq 'ssh-slaves'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'enabled? is true' do
      expect(subject.enabled?).to eq true
    end

    it 'disabled? is false' do
      expect(subject.disabled?).to eq false
    end

    it 'version' do
      expect(subject.version).to eq '1.28.1'
    end
  end

  context 'disabled ssh-slaves plugin' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}/META-INF/MANIFEST.MF", :file? => true, content: job_file_content)
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}.jpi.disabled", :file? => true)
    end

    let(:plugin_name) { 'ssh-slaves' }
    
    it 'name is ssh-slaves' do
      expect(subject.name).to eq 'ssh-slaves'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'enabled? is false' do
      expect(subject.enabled?).to eq false
    end

    it 'disabled? is true' do
      expect(subject.disabled?).to eq true
    end

    it 'version' do
      expect(subject.version).to eq '1.28.1'
    end
  end

  context 'missing plugin' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}/META-INF/MANIFEST.MF", :file? => false)
      stub_inspec_file("/var/lib/jenkins/plugins/#{plugin_name}.jpi.disabled", :file? => false)
    end

    let(:plugin_name) { 'missing' }
    
    it 'name is missing' do
      expect(subject.name).to eq 'missing'
    end

    it 'exist? is false' do
      expect(subject.exist?).to eq false
    end

    it 'enabled? is false' do
      expect(subject.enabled?).to eq false
    end

    it 'disabled? is true' do
      expect(subject.disabled?).to eq true
    end

    it 'version' do
      expect(subject.version).to be_nil
    end
  end
end
