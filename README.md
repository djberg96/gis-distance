## Description
The gis-distance library allows you to calculate geographic distance between
two points using the formula of your choice.

## Installation
`gem install gis-distance`

## Synopsis
```ruby
require 'gis/distance' # or 'gis-distance'

# New York to Los Angeles
gis = GIS::Distance.new(40.47, 73.58, 34.3, 118.15)

# Set the formula of your choice
gis.formula = 'cosines'
gis.formula = 'haversine'

p gis.distance    # Kilometers
p gis.distance.mi # Miles 
```

## Available Formulas
* haversine (https://en.wikipedia.org/wiki/Haversine_formula)
* cosine (https://en.wikipedia.org/wiki/Law_of_cosines)

## See Also
http://en.wikipedia.org/wiki/Earth_radius

## License
Artistic 2.0

## Authors
* Daniel Berger
* Ardith Falkner
