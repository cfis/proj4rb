# frozen_string_literal: true

require 'proj'

# Transform a bounding box from geographic to projected coordinates.
transform = Proj::Transformation.new('EPSG:4326',
  '+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs')

# Bounding box covering parts of North America (lat_min, lon_min, lat_max, lon_max).
bounds = Proj::Bounds.new(40, -120, 64, -80)
result = transform.transform_bounds(bounds, :PJ_FWD, 21)

puts "Input:  xmin=#{bounds.xmin}, ymin=#{bounds.ymin}, xmax=#{bounds.xmax}, ymax=#{bounds.ymax}"
puts "Output: xmin=#{result.xmin.round(2)}, ymin=#{result.ymin.round(2)}, xmax=#{result.xmax.round(2)}, ymax=#{result.ymax.round(2)}"

raise 'transform_bounds failed' unless result.xmin.finite? && result.ymax.finite?

puts 'ok'
