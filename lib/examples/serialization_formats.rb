# frozen_string_literal: true

require 'json'
require 'proj'

crs = Proj::Crs.new('EPSG:4326')
wkt = crs.to_wkt(:PJ_WKT2_2019, multiline: false)
projjson = crs.to_json(multiline: false)
proj_str = crs.to_proj_string

raise 'wkt missing' if wkt.nil? || wkt.empty?
raise 'proj string missing' if proj_str.nil? || proj_str.empty?

parsed = JSON.parse(projjson)
raise 'projjson parse failed' unless parsed['type']

puts "ok: serialized #{crs.auth}"
