# frozen_string_literal: true

require 'proj'

# Create a UTM zone 32 conversion.
conversion = Proj::Conversion.new('+proj=utm +zone=32 +ellps=GRS80')

# Build an array of coordinates (lon/lat in radians).
coordinates = [
  Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(55), z: 45),
  Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(56), z: 50),
  Proj::Coordinate.new(lon: Proj.degrees_to_radians(13), lat: Proj.degrees_to_radians(55), z: 30)
]

# Transform all at once (more efficient than looping).
results = conversion.transform_array(coordinates, :PJ_FWD)

results.each_with_index do |coord, i|
  puts "Point #{i}: x=#{coord.x.round(2)}, y=#{coord.y.round(2)}, z=#{coord.z}"
end

raise 'wrong count' unless results.size == 3
raise 'bad transform' unless results.all? { |c| c.x.finite? && c.y.finite? }

puts 'ok'
