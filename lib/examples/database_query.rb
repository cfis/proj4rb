# frozen_string_literal: true

require 'proj'

database = Proj::Database.new(Proj::Context.current)

# List all authorities in the database.
authorities = database.authorities
puts "Authorities: #{authorities.to_a.first(5).join(', ')} (#{authorities.count} total)"

# Count EPSG coordinate reference systems.
codes = database.codes('EPSG', :PJ_TYPE_GEOGRAPHIC_2D_CRS)
puts "EPSG geographic 2D CRS codes: #{codes.count}"

# Query CRS entries for a specific authority.
crs_infos = database.crs_info('EPSG')
puts "EPSG CRS entries: #{crs_infos.count}"

# Show the first entry.
info = crs_infos.first
puts "First: #{info.auth_name}:#{info.code} - #{info.name} (#{info.crs_type})"
puts "  Area: #{info.area_name}"
puts "  Bounds: W=#{info.west_lon_degree}, S=#{info.south_lat_degree}, E=#{info.east_lon_degree}, N=#{info.north_lat_degree}"

raise 'no CRS info found' if crs_infos.empty?

puts 'ok'
