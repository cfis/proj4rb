$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'proj4'
include Proj4

proj = Projection.new(["proj=utm","zone=21","units=m","no.defs"])

uv = UV.new(45000,2700000)

res = proj.inverse(uv)

puts res.u ,res.v




