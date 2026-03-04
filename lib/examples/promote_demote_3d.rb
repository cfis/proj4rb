# frozen_string_literal: true

require 'proj'

# Start with a 2D geographic CRS.
crs_2d = Proj::Crs.new('EPSG:4326')
puts "Original: #{crs_2d.name}"
puts "  Type: #{crs_2d.proj_type}"

# Promote to 3D (adds an ellipsoidal height axis).
crs_3d = crs_2d.promote_to_3d
puts "Promoted: #{crs_3d.name}"
puts "  Type: #{crs_3d.proj_type}"

# Demote back to 2D.
crs_back = crs_3d.demote_to_2d
puts "Demoted:  #{crs_back.name}"
puts "  Type: #{crs_back.proj_type}"

raise 'promote failed' unless crs_3d.proj_type == :PJ_TYPE_GEOGRAPHIC_3D_CRS
raise 'demote failed'  unless crs_back.proj_type == :PJ_TYPE_GEOGRAPHIC_2D_CRS

puts 'ok'
