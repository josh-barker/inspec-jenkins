require 'spec_helper'

require_relative '../../libraries/jenkins_job'

describe JenkinsJob do
  let(:subject) { described_class.new(job_name) }

  let(:root_dir) { Dir.pwd }
  let(:job_file) { File.join(root_dir, 'spec', 'mock', 'jenkins_job', "#{job_name}.xml") }
  let(:job_file_content) { IO.read(job_file) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)
  end
  
  context 'job that is disabled' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/jobs/#{job_name}/config.xml", :file? => true, content: job_file_content)
    end

    let(:job_name) { 'disable-simple-execute' }
    
    it 'name is disable-simple-execute' do
      expect(subject.name).to eq 'disable-simple-execute'
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

    it 'command is set' do
      expect(subject.command).to eq "echo \"This is Jenkins! Hear me roar!\""
    end

    it 'plugin is set' do
      expect(subject.plugin).to eq nil
    end
  end

  context 'job that is enabled' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/jobs/#{job_name}/config.xml", :file? => true, content: job_file_content)
    end

    let(:job_name) { 'enable-simple-execute' }
    
    it 'name is enable-simple-execute' do
      expect(subject.name).to eq 'enable-simple-execute'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'disabled? is false' do
      expect(subject.disabled?).to eq false
    end

    it 'enabled? is true' do
      expect(subject.enabled?).to eq true
    end

    it 'command is set' do
      expect(subject.command).to eq "echo \"This is Jenkins! Hear me roar!\""
    end

    it 'plugin is set' do
      expect(subject.plugin).to eq nil
    end
  end

  context 'job with parameters' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/jobs/#{job_name}/config.xml", :file? => true, content: job_file_content)
    end

    let(:job_name) { 'enable-simple-execute' }
    
    it 'name is enable-simple-execute' do
      expect(subject.name).to eq 'enable-simple-execute'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'disabled? is false' do
      expect(subject.disabled?).to eq false
    end

    it 'enabled? is true' do
      expect(subject.enabled?).to eq true
    end

    it 'command is set' do
      expect(subject.command).to eq "echo \"This is Jenkins! Hear me roar!\""
    end

    it 'plugin is set' do
      expect(subject.plugin).to eq nil
    end
  end

  context 'job with parameters' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/jobs/#{job_name}/config.xml", :file? => true, content: job_file_content)
    end

    let(:job_name) { 'my-folder' }
    
    it 'name is my-folder' do
      expect(subject.name).to eq 'my-folder'
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

    it 'command is set' do
      expect(subject.command).to be_nil
    end

    it 'plugin is set' do
      expect(subject.plugin).to eq 'cloudbees-folder@4.6.1'
    end
  end

  context 'job that is missing' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/jobs/#{job_name}/config.xml", :file? => false)
    end

    let(:job_name) { 'missing' }
    
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

    it 'command is set' do
      expect(subject.command).to be_nil
    end

    it 'plugin is set' do
      expect(subject.plugin).to be_nil
    end
  end
end
