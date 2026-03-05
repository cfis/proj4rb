# frozen_string_literal: true

require 'proj'

area = Proj::Area.new(
  west_lon_degree: -114.1324,
  south_lat_degree: 49.5614,
  east_lon_degree: 3.76488,
  north_lat_degree: 62.1463
)

transform = Proj::Transformation.new('EPSG:4277', 'EPSG:4326', area: area)
from = Proj::Coordinate.new(x: 50, y: -2)
to = transform.forward(from)

raise 'area transformation failed' unless to.x.finite? && to.y.finite?

puts "ok: transformed x=#{to.x}, y=#{to.y}"
