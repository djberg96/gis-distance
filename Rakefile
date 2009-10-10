require 'rake'
require 'rake/testtask'
include Config

desc "Install the gis-distance library"
task :install_lib do
   dest = File.join(CONFIG['sitelibdir'], 'gis')
   Dir.mkdir(dest) unless File.exists? dest
   cp 'lib/gis/distance.rb', dest, :verbose => true
end

desc 'Build the gis-distance gem'
task :gem do
   spec = eval(IO.read('gis-distance.gemspec'))
   Gem::Builder.new(spec).build
end

desc 'Install the gis-distance library as a gem'
task :install_gem => [:gem] do
   file = Dir["*.gem"].first
   sh "gem install #{file}"
end

Rake::TestTask.new do |t|
   t.warning = true
   t.verbose = true
end
