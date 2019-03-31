require 'spec_helper'

require_relative '../../libraries/jenkins_user'

describe JenkinsUser do
  let(:subject) { described_class.new(user_id) }

  let(:job_file) { File.join(Dir.pwd, 'spec', 'mock', 'jenkins_user', "#{user_id}.xml") }
  let(:job_file_content) { IO.read(job_file) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)
  end
  
  context 'simple user' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/users/#{user_id}/config.xml", :file? => true, content: job_file_content)
    end

    let(:user_id) { 'badger' }

    it 'id is badger' do
      expect(subject.id).to eq 'badger'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'email is set' do
      expect(subject.email).to eq 'badger@chef.io'
    end

    it 'full_name is set' do
      expect(subject.full_name).to eq 'Badger Badger'
    end

    it 'publickey is set' do
      expect(subject.public_key).to eq []
    end

    it 'password_hash is set' do
      expect(subject.password_hash).to be_nil
    end
  end

  context 'user with public keys and password hash' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/users/#{user_id}/config.xml", :file? => true, content: job_file_content)
    end

    let(:user_id) { 'chef' }

    it 'id is chef' do
      expect(subject.id).to eq 'chef'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'email is set' do
      expect(subject.email).to eq nil
    end

    it 'full_name is set' do
      expect(subject.full_name).to eq 'Chef Client'
    end

    it 'public key is set' do
      expect(subject.public_key).to eq ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO66p1CYctGZW/eq8ywBqV4+/AxIinZa4SrZhIf3ShGVihFryHiVPYKVhwh7t01/hU1bc085ZUFFafcX1Ie3Gt8K1Ltfmmtik+EFFRZ3FAy+4Ye8XnFTyr3e2O9m/tg9YG/E/1HeeW8frrW40Ub7CJYpZp8xPqCyj5+vyHytnBT6g/XXgt0vcl8jQGAnytj6UN+DZc3EvPnKyTIjXHlYgvTE3EWJgThe5BUu7b1+rO0aQVI4tlHjVce4iLnN+0E3GQuE9Kkzblq418LtkB6hgTQEKGP2MPa7MX3zdH19P0F+SwBRS60X/40uhgp5X94VZIlJODXL8Z8SFNnYfr0LhF']
    end

    it 'password hash is set' do
      expect(subject.password_hash).to eq '#jbcrypt:$2a$10$v/OAHF/TNHo7E7oYwLt1ROzJOsC0ONJIPZ8hXIqkLWywx9YKrGO5C'
    end
  end

  context 'user with password hash' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/users/#{user_id}/config.xml", :file? => true, content: job_file_content)
    end

    let(:user_id) { 'random-bob' }

    it 'id is random-bob' do
      expect(subject.id).to eq 'random-bob'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'email is set' do
      expect(subject.email).to eq nil
    end

    it 'full_name is set' do
      expect(subject.full_name).to eq 'random-bob'
    end

    it 'public key is set' do
      expect(subject.public_key).to eq []
    end

    it 'password hash is set' do
      expect(subject.password_hash).to eq '#jbcrypt:$2a$10$Hn11b/FgGlaHsRw/XPhCx.muSoEk6oU.YvO5F50gA78ybfL6vQYiK'
    end
  end

  context 'user with multiple public keys' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/users/#{user_id}/config.xml", :file? => true, content: job_file_content)
    end

    let(:user_id) { 'valyukov' }

    it 'id is valyukov' do
      expect(subject.id).to eq 'valyukov'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'email is set' do
      expect(subject.email).to eq 'valyukov@gmail.com'
    end

    it 'full_name is set' do
      expect(subject.full_name).to eq 'Vlad Alyukov'
    end

    it 'public key is set' do
      expect(subject.public_key).to eq ['ssh-rsa BBBBBBB', 'ssh-rsa CCCCCCC']
    end

    it 'password hash is set' do
      expect(subject.password_hash).to eq '#jbcrypt:$2a$10$7.zHKjWeRYnZgrIRIh3b.uX6Nf0A1q7.GjgVR1vh.ayt2U52I8D1G'
    end
  end

  context 'user that is missing' do
    before(:each) do
      stub_inspec_file("/var/lib/jenkins/users/#{user_id}/config.xml", :file? => false)
    end

    let(:user_id) { 'missing' }

    it 'id is missing' do
      expect(subject.id).to eq 'missing'
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq false
    end

    it 'email is set' do
      expect(subject.email).to be_nil
    end

    it 'full_name is set' do
      expect(subject.full_name).to be_nil
    end

    it 'public key is set' do
      expect(subject.public_key).to eq []
    end

    it 'password hash is set' do
      expect(subject.password_hash).to be_nil
    end
  end
end

