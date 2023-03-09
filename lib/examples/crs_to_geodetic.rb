# The following example illustrates how to convert between a CRS and geodetic coordinates for that CRS.
# See https://proj.org/development/quickstart.html

require 'bundler/setup'
require 'proj'

# Create a context
context = Proj::Context.new

# Create a projection
crs = Proj::Crs.new("+proj=utm +zone=32 +datum=WGS84 +type=crs", context)

# Get the geodetic CRS for that projection
geodetic_crs = crs.geodetic_crs
puts geodetic_crs.to_proj_string
# +proj=longlat +datum=WGS84 +no_defs +type=crs


# Create a transformation from the geodetic to projected coordinates
transformation = Proj::Transformation.new(geodetic_crs, crs, context)
puts transformation.to_proj_string
# +proj=pipeline +step +proj=unitconvert +xy_in=deg +xy_out=rad +step +proj=utm +zone=32 +ellps=WGS84

# Create a coordinate for Copenhagen in degrees
coordinate_geodetic = Proj::Coordinate.new(lon: 12.0, lat: 55.0)
puts "lon: #{coordinate_geodetic.lon}, lat:  #{coordinate_geodetic.lat}"

# Transform the coordinate
coordinate_projected = transformation.forward(coordinate_geodetic)
# lon: 12.0, lat:  55.0

puts "east: #{coordinate_projected.e}, north: #{coordinate_projected.n}"
# east: 691875.632137542, north: 6098907.825129169

puts "x: #{coordinate_projected.x}, y: #{coordinate_projected.y}"
# x: 691875.632137542, y: 6098907.825129169

# Apply the inverse transform
coordinate_inverse = transformation.inverse(coordinate_projected)

puts "lon: #{coordinate_inverse.lon}, lat:  #{coordinate_inverse.lat}"
# lon: 12.0, lat:  55.0

puts coordinate_geodetic == coordinate_inverse
# true
