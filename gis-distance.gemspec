require 'rubygems'

Gem::Specification.new do |gem|
   gem.name        = 'gis-distance'
   gem.version     = '1.0.0' 
   gem.authors     = ['Daniel J. Berger', 'Ardith Faulkner']
   gem.license     = 'Artistic 2.0'
   gem.description = 'Calculate the distance between 2 points on Earth'
   gem.email       = 'djberg96@gmail.com'
   gem.files       = Dir['**/*'].reject{ |f| f.include?('CVS') }
   gem.test_files  = ['test/test_gis_distance.rb']
   gem.has_rdoc    = true
   gem.homepage    = 'http://github.com/djberg96/gis-distance'

   gem.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']

   gem.summary = <<-EOF
      The gis-distance library provides a simple interface for
      calculating the distance between two points on Earth using
      latitude and longitude.
   EOF
end
