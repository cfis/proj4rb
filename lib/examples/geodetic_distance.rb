# frozen_string_literal: true

require 'proj'

# Use WGS 84 as the ellipsoid for distance calculations.
crs = Proj::Crs.new('EPSG:4326')

# Paris (lon, lat) and Berlin (lon, lat) in radians.
paris  = Proj::Coordinate.new(x: Proj.degrees_to_radians(2.3522),
                               y: Proj.degrees_to_radians(48.8566))
berlin = Proj::Coordinate.new(x: Proj.degrees_to_radians(13.4050),
                               y: Proj.degrees_to_radians(52.5200))

# Simple geodesic distance on the ellipsoid.
distance = crs.lp_distance(paris, berlin)
raise "unexpected distance #{distance}" unless (distance - 878_000).abs < 5_000

puts "Distance Paris -> Berlin: #{(distance / 1000).round(1)} km"

# Full geodesic: distance + forward/reverse azimuth.
# Returns distance (meters) in x, forward azimuth (degrees) in y, reverse azimuth (degrees) in z.
result = crs.geod_distance(paris, berlin)
puts "Geodesic distance: #{(result.x / 1000).round(1)} km"
puts "Forward azimuth:   #{result.y.round(2)} degrees"
puts "Reverse azimuth:   #{result.z.round(2)} degrees"

# Geodesic direct problem (PROJ 9.7+): given a start point, azimuth, and distance,
# compute the endpoint.
if Proj::Api::PROJ_VERSION >= Gem::Version.new('9.7.0')
  # From Paris, azimuth 0 (due north), 100 km.
  endpoint = crs.geod_direct(paris, 0.0, 100_000)
  puts "100 km north of Paris: lon=#{Proj.radians_to_degrees(endpoint.x).round(4)}, lat=#{Proj.radians_to_degrees(endpoint.y).round(4)}"
  raise 'geod_direct failed' unless endpoint.x.finite? && endpoint.y.finite?
else
  puts "geod_direct requires PROJ 9.7+ (have #{Proj::Api::PROJ_VERSION})"
end

puts 'ok'
