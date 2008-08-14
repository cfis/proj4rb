#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

if ARGV[0] == '-v'
    puts "%-8s %-20s %-50s" % [ 'ID', 'To meter', 'Name' ]
    puts "------------------------------------------------------------------------------"
    Unit.list.sort.each do |unit|
        puts "%-8s %-20s %-50s" % [ unit.id, unit.to_meter, unit.name ]
    end
else
    puts Unit.list.sort
end

