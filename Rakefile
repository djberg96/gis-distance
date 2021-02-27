require 'rake'
require 'rake/clean'
require 'rbconfig'
require 'rspec/core/rake_task'

CLEAN.include('**/*.gem', '**/*.log')

namespace 'gem' do
  desc 'Create the gis-distance gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('gis-distance.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc 'Install the gis-distance gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

desc "Run the test suite"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
