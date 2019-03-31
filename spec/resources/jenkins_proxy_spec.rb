require 'spec_helper'

require_relative '../../libraries/jenkins_proxy'

describe JenkinsProxy do
  let(:subject) { described_class.new('5.6.7.8') }

  let(:job_file) { File.join(Dir.pwd, 'spec', 'mock', 'jenkins_proxy', 'proxy.xml') }
  let(:job_file_content) { IO.read(job_file) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)
  end
  
  context 'proxy is configured' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/proxy.xml", :file? => true, content: job_file_content)
    end

    it 'name is 5.6.7.8' do
      expect(subject.name).to eq '5.6.7.8'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'port is 9012' do
      expect(subject.port).to eq 9012
    end

    it 'noproxy is set' do
      expect(subject.noproxy).to eq ["nohost", "*.nodomain"]
    end
  end

  context 'proxy is not configured' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/proxy.xml", :file? => false)
    end

    it 'name is nil' do
      expect(subject.name).to be_nil
    end

    it 'exist? is false' do
      expect(subject.exist?).to eq false
    end

    it 'port is nil' do
      expect(subject.port).to be_nil
    end

    it 'noproxy is nil' do
      expect(subject.noproxy).to eq []
    end
  end
end
