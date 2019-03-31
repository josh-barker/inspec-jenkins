require 'spec_helper'

require_relative '../../libraries/jenkins_credentials'
require_relative '../../libraries/jenkins_user_credentials'

describe JenkinsUserCredentials do
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

    let(:username) { 'schisamo' }
    
    it 'username is schisamo' do
      expect(subject.username).to eq 'schisamo'
    end

    it 'id is schisamo' do
      expect(subject.id).to eq 'schisamo'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'passwords are for suckers'
    end

    it 'has_password? is true' do
      expect(subject.has_password?).to eq true
    end

    it 'has_private_key? is false' do
      expect(subject.has_private_key?).to eq false
    end

    it 'has_passphrase? is false' do
      expect(subject.has_passphrase?).to eq false
    end
  end

  context 'user with private key' do
    before(:each) do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: credential_file_content)
    end

    let(:username) { 'jenkins' }

    it 'username is jenkins' do
      expect(subject.username).to eq 'jenkins'
    end

    it 'id is jenkins' do
      expect(subject.id).to eq 'jenkins'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'this is more like it'
    end

    it 'has_password? is false' do
      expect(subject.has_password?).to eq false
    end

    it 'has_private_key? is true' do
      expect(subject.has_private_key?).to eq true
    end

    it 'has_passphrase? is false' do
      expect(subject.has_passphrase?).to eq false
    end
  end

  context 'user with passphrase' do
    before(:each) do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: credential_file_content)
    end

    let(:username) { 'jenkins2' }

    it 'username is jenkins2' do
      expect(subject.username).to eq 'jenkins2'
    end
    
    it 'id is jenkins2' do
      expect(subject.id).to eq 'jenkins2'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'description is set' do
      expect(subject.description).to eq 'Credentials for jenkins2 - created by Chef'
    end

    it 'has_password? is false' do
      expect(subject.has_password?).to eq false
    end

    it 'has_private_key? is true' do
      expect(subject.has_private_key?).to eq true
    end

    it 'has_passphrase? is true' do
      expect(subject.has_passphrase?).to eq true
    end
  end

  context 'missing user' do
    before(:each) do
      stub_inspec_file('/var/lib/jenkins/credentials.xml', :file? => true, content: credential_file_content)
    end

    let(:username) { 'missing' }
    
    it 'username is missing' do
      expect(subject.username).to eq 'missing'
    end

    it 'id is missing' do
      expect(subject.id).to be_nil
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq false
    end

    it 'description is set' do
      expect(subject.description).to be_nil
    end

    it 'has_password? is false' do
      expect(subject.has_password?).to eq false
    end

    it 'has_private_key? is false' do
      expect(subject.has_private_key?).to eq false
    end

    it 'has_passphrase? is false' do
      expect(subject.has_passphrase?).to eq false
    end
  end
end
