require 'rubygems'

Gem::Specification.new do |spec|
  spec.name        = 'gis-distance'
  spec.version     = '1.0.2'
  spec.authors     = ['Daniel J. Berger', 'Ardith Falkner']
  spec.license     = 'Artistic-2.0'
  spec.description = 'Calculate the distance between two points on Earth'
  spec.email       = 'djberg96@gmail.com'
  spec.files       = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.test_files  = Dir['spec/*_spec.rb']
  spec.homepage    = 'http://github.com/djberg96/gis-distance'
  spec.cert_chain  = ['certs/djberg96_pub.pem']

  spec.add_development_dependency('rspec', '~> 3.9')

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/djberg96/gis-distance',
    'bug_tracker_uri'   => 'https://github.com/djberg96/gis-distance/issues',
    'changelog_uri'     => 'https://github.com/djberg96/gis-distance/blob/master/CHANGES',
    'documentation_uri' => 'https://github.com/djberg96/gis-distance/wiki',
    'source_code_uri'   => 'https://github.com/djberg96/gis-distance',
    'wiki_uri'          => 'https://github.com/djberg96/gis-distance/wiki'
  }

  spec.summary = <<-EOF
    The gis-distance library provides a simple interface for
    calculating the distance between two points on Earth using
    latitude and longitude.
  EOF
end
