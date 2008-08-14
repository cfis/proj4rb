#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

# create projection object
proj = Projection.new(["proj=utm", "zone=21", "units=m", "no.defs"])

# create the point you want to project
point = Point.new(45000,2700000)

# do the projection
res = proj.inverse(point)

puts "x=#{point.x}, y=#{point.y} ==> lon=#{res.lon}, lat=#{res.lat}"

