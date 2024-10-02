[![Ruby](https://github.com/djberg96/gis-distance/actions/workflows/ruby.yml/badge.svg)](https://github.com/djberg96/gis-distance/actions/workflows/ruby.yml)

## Description
The gis-distance library allows you to calculate geographic distance between
two points using the formula of your choice.

## Installation
`gem install gis-distance`

## Adding the trusted cert
`gem cert --add <(curl -Ls https://raw.githubusercontent.com/djberg96/gis-distance/main/certs/djberg96_pub.pem)`

## Synopsis
```ruby
require 'gis/distance' # or 'gis-distance'

# New York to Los Angeles
gis = GIS::Distance.new(40.47, 73.58, 34.3, 118.15)

# Set the formula of your choice
gis.formula = 'cosines'
gis.formula = 'haversine'
gis.formula = 'vincenty'

p gis.distance    # Kilometers
p gis.distance.mi # Miles 
```

## Available Formulas
* haversine (https://en.wikipedia.org/wiki/Haversine_formula)
* cosine (https://en.wikipedia.org/wiki/Law_of_cosines)
* vincenty (https://en.wikipedia.org/wiki/Vincenty%27s_formulae)

## See Also
http://en.wikipedia.org/wiki/Earth_radius

## Miscellaneous
Ruby 2.x was dropped from the test matrix as of version 1.2 because of
incompatibility with bundler. This library should still work fine with
older versions of Ruby, but you should strongly consider upgrading at this
point since Ruby 2.x is now EOL.

## License
Artistic-2.0

## Authors
* Daniel Berger
* Ardith Falkner
