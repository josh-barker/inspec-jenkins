require 'spec_helper'

require_relative '../../libraries/jenkins_credentials'

describe JenkinsCredentials do
  let(:subject) { described_class.new(username) }

  let(:username) { 'first' }

  let(:root_dir) { Dir.pwd }
  let(:credential_file_content) { IO.read(File.join(root_dir, 'spec', 'mock', 'jenkins_credentials', 'credentials.xml')) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)
  end

  context '#initialize' do
    it 'sets username' do
      expect(subject.username).to eq 'first'
    end
  end

  context 'reads credentials xml file' do
    it 'when file is missing returns nil' do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => false, content: '<some>content</some>')

      expect(subject.send(:doc)).to be_nil
    end

    it 'when file is exists returns XML Document' do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: '<some>content</some>')

      expect(subject.send(:doc)).to be_a(REXML::Document)
      expect(subject.send(:doc).to_s).to eq '<some>content</some>'
    end

    it 'when file is exists and XML is malformed, raises error' do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: '<some>')

      expect { subject.send(:doc) }.to raise_error(REXML::ParseException)
    end
  end
end
