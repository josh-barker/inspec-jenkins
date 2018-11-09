# require 'bundler'
# require 'bundler/gem_tasks'

# Bundler::GemHelper.install_tasks name: 'inspec-jenkins', dir: 'vendor'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = "**{,/*/**}/*_spec.rb"
  end
rescue LoadError
  puts 'rspec is not available. Install the rspec gem to run the unit tests.'
end

# Rubocop
begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:lint)
rescue LoadError
  puts 'rubocop is not available. Install the rubocop gem to run the lint tests.'
end

task default: [:spec, :lint]
