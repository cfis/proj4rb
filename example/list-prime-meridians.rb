#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

if ARGV[0] == '-v'
    puts "%-16s %-50s" % [ 'ID', 'Definition' ]
    puts '-----------------------------------------------------------------------------'
    PrimeMeridian.list.sort.each do |pm|
        puts "%-16s %-50s" % [ pm.id, pm.defn ]
    end
else
    puts PrimeMeridian.list.sort
end

