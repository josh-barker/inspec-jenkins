require 'inspec'
require 'ostruct'
require 'rspec'

require 'simplecov'
SimpleCov.start

require_relative '../libraries/jenkins_base'

RSpec.configure do |config|
  config.color = true
  config.default_formatter = 'doc'

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end

RSpec.shared_examples 'good builds' do
  it 'name is correct' do
    expect(subject.build_name).to eq name
  end

  it 'build_number is 1' do
    expect(subject.build_number).to eq 1
  end

  it 'exist? is true' do
    expect(subject.exist?).to eq true
  end

  it 'parameters are set' do
    expect(subject.parameters).to eq({ "BOOLEAN_PARAM" => true, "STRING_PARAM" => "meeseeks" })
  end
end

RSpec.shared_examples 'bad builds' do
  it 'name is correct' do
    expect(subject.build_name).to eq name
  end

  it 'build_number is nil' do
    expect(subject.build_number).to be_nil
  end

  it 'exist? is false' do
    expect(subject.exist?).to eq false
  end

  it 'parameters is empty' do
    expect(subject.parameters).to be_empty
  end
end

def stub_inspec_file(path, **options)
  file_double = double(path, **options)
  allow(subject).to receive_message_chain(:inspec, :backend, :file).with(path).and_return(file_double)
end
