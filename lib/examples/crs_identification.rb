# frozen_string_literal: true

require 'proj'

# Start with a CRS created from a well-known string.
crs = Proj::Crs.new('OGC:CRS84')

# Identify it against the OGC authority.
objects, confidences = crs.identify('OGC')

objects.count.times do |i|
  puts "Match: #{objects[i]} (confidence: #{confidences[i]}%)"
end

raise 'no matches' if objects.count.zero?
raise 'low confidence' if confidences[0] < 100

puts 'ok'
