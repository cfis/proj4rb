# frozen_string_literal: true

require 'proj'

context = Proj::Context.new
crs_projected = Proj::Crs.new('+proj=utm +zone=32 +datum=WGS84 +type=crs', context)
crs_geodetic = crs_projected.geodetic_crs
transform = Proj::Transformation.new(crs_geodetic, crs_projected, context)

from = Proj::Coordinate.new(lon: 12.0, lat: 55.0)
to = transform.forward(from)
back = transform.inverse(to)

raise 'forward failed' unless to.x.finite? && to.y.finite?
raise 'inverse mismatch lon' unless (back.lon - 12.0).abs < 1e-8
raise 'inverse mismatch lat' unless (back.lat - 55.0).abs < 1e-8

puts "ok: projected x=#{to.x}, y=#{to.y}"
