require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include RbConfig

CLEAN.include('**/*.gem', '**/*.log')

namespace 'gem' do
  desc 'Create the gis-distance gem'
  task :create => [:clean] do
    spec = eval(IO.read('gis-distance.gemspec'))

    if Gem::VERSION < "2.0"
      Gem::Builder.new(spec).build
    else
      require 'rubygems/package'
      Gem::Package.build(spec)
    end
  end

  desc 'Install the gis-distance gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
end

task :default => :test
