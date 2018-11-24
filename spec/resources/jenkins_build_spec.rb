require 'spec_helper'

require_relative '../../libraries/jenkins_build'

describe JenkinsBuild do
  
  let(:subject) { described_class.new(name, build_number) }

  let(:name) { 'first' }

  let(:build_number) { '1' }
  let(:build_number_response_url) { "http://localhost:8080/job/#{name}/#{computed_build_number}/api/json?pretty=true" }
  let(:build_body) { }
  let(:build_status) { }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:inspec)

    http = OpenStruct.new(JSON.parse(IO.read(build_file_name), symbolize_names: true))
    allow_any_instance_of(described_class).to receive(:rest_call).with('GET', "http://localhost:8080/job/#{name}/api/json?pretty=true", {}).and_return(http)

    http = OpenStruct.new(JSON.parse(IO.read(build_id_file_name), symbolize_names: true))
    allow_any_instance_of(described_class).to receive(:rest_call).with('GET', build_number_response_url, {}).and_return(http)
  end

  let(:root_dir) { Dir.pwd }
  let(:computed_build_number) { }
  let(:build_file_name) { File.join(root_dir, 'spec', 'mock', 'jenkins_build', 'by_build', "#{name}-#{computed_build_number}.json") }
  let(:build_id_file_name) { File.join(root_dir, 'spec', 'mock', 'jenkins_build', 'by_build_and_id', "json-#{name}-#{computed_build_number}.json") }

  context 'lastSuccessfulBuild' do
    let(:name) { 'simple-execute' }
    let(:build_number) { 'lastSuccessfulBuild' }
    let(:computed_build_number) { '1' }

    it 'name is correct' do
      expect(subject.build_name).to eq name
    end

    it 'build_number is 1' do
      expect(subject.build_number).to eq 1
    end

    it 'exist? is true' do
      expect(subject.exist?).to eq true
    end

    it 'result is true' do
      expect(subject.result).to eq "SUCCESS"
    end

    it 'parameters is empty' do
      expect(subject.parameters).to be_empty
      expect(subject.parameters).to be_a(Hash)
    end
  end

  context 'execute-with-params' do
    let(:name) { 'execute-with-params' }

    context 'good' do
      context 'lastBuild' do
        let(:build_number) { 'lastBuild' }
        let(:computed_build_number) { '1' }

        include_examples 'good builds'
      end

      context 'lastCompletedBuild' do
        let(:build_number) { 'lastCompletedBuild' }
        let(:computed_build_number) { '1' }

        include_examples 'good builds'
      end

      context 'lastStableBuild' do
        let(:build_number) { 'lastStableBuild' }
        let(:computed_build_number) { '1' }
  
        include_examples 'good builds'
      end

      context 'lastSuccessfulBuild' do
        let(:build_number) { 'lastSuccessfulBuild' }
        let(:computed_build_number) { '1' }
  
        include_examples 'good builds'
      end
    end

    context 'bad' do
      context 'lastFailedBuild' do
        let(:build_number) { 'lastFailedBuild' }
        let(:computed_build_number) { '1' }

        include_examples 'bad builds'
      end

      context 'lastUnsuccessfulBuild' do
        let(:build_number) { 'lastUnsuccessfulBuild' }
        let(:computed_build_number) { '1' }

        include_examples 'bad builds'
      end

      context 'wrong-tag' do
        let(:build_number) { 'wrong-tag' }
        let(:computed_build_number) { '1' }

        include_examples 'bad builds'
      end
    end
  end

  context 'missing-job' do
    let(:name) { 'missing-job' }
    let(:build_number) { 'lastSuccessfulBuild' }
    let(:computed_build_number) { '1' }

    include_examples 'bad builds'
  end

  context 'simple-execute' do
    let(:name) { 'simple-execute' }

    context '1' do
      let(:build_number) { '1' }
      let(:computed_build_number) { '1' }

      it 'name is correct' do
        expect(subject.build_name).to eq name
      end
    
      it 'build_number is 1' do
        expect(subject.build_number).to eq 1
      end
    
      it 'exist? is true' do
        expect(subject.exist?).to eq true
      end
    
      it 'parameters is empty' do
        expect(subject.parameters).to be_empty
      end
    end

    context 'lastSuccessfulBuild' do
      let(:build_number) { 'lastSuccessfulBuild' }
      let(:computed_build_number) { '1' }

      it 'name is correct' do
        expect(subject.build_name).to eq name
      end
    
      it 'build_number is 1' do
        expect(subject.build_number).to eq 1
      end
    
      it 'exist? is true' do
        expect(subject.exist?).to eq true
      end
    
      it 'parameters is empty' do
        expect(subject.parameters).to be_empty
      end
    end
  end
end
