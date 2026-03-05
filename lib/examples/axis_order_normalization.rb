# frozen_string_literal: true

require 'proj'

transform = Proj::Transformation.new('EPSG:4326', 'EPSG:3857')
normalized = transform.normalize_for_visualization

coord = Proj::Coordinate.new(x: -122.4194, y: 37.7749)
result = normalized.forward(coord)

raise 'normalization transform failed' unless result.x.finite? && result.y.finite?

puts "ok: web mercator x=#{result.x}, y=#{result.y}"
