require 'spec_helper'

require_relative '../../libraries/jenkins_credentials'
require_relative '../../libraries/jenkins_secret_text_credentials'

describe JenkinsSecretTextCredentials do
  let(:subject) { described_class.new(username) }

  let(:username) { 'first' }

  let(:credential_file) { File.join(Dir.pwd, 'spec', 'mock', 'jenkins_credentials', 'credentials.xml') }
  let(:credential_file_content) { IO.read(credential_file) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)
  end
  
  context 'user with password' do
    before(:each) do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: credential_file_content)
    end

    let(:username) { 'dollarbills_secret' }
    
    it 'description is dollarbills_secret' do
      expect(subject.description).to eq 'dollarbills_secret'
    end

    it 'id is dollarbills_secret' do
      expect(subject.id).to eq 'dollarbills_secret'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'dollarbills_secret'
    end

    it 'has_secret? is true' do
      expect(subject.has_secret?).to eq true
    end
  end

  context 'missing user' do
    before(:each) do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: credential_file_content)
    end

    let(:username) { 'missing' }
    
    it 'description is set' do
      expect(subject.description).to eq 'missing'
    end

    it 'id is missing' do
      expect(subject.id).to be_nil
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq false
    end

    it 'has_secret? is false' do
      expect(subject.has_secret?).to eq false
    end
  end
end
