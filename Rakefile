require 'rake'
require 'rake/clean'
require 'rbconfig'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

CLEAN.include('**/*.gem', '**/*.log', '**/*.lock')

namespace 'gem' do
  desc 'Create the gis-distance gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = Gem::Specification.load('gis-distance.gemspec')
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc 'Install the gis-distance gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

RuboCop::RakeTask.new

desc "Run the test suite"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.rspec_opts = '-f documentation'
end

# Clean up afterwards
Rake::Task[:spec].enhance do
  Rake::Task[:clean].invoke
end

task :default => :spec
