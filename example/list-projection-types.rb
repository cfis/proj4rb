#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

if ARGV[0] == '-v'
    puts "%-7s %-70s" % [ 'ID', 'Name/Description' ]
    puts '-----------------------------------------------------------------------------'
    ProjectionType.list.sort.each do |pt|
        puts "%-7s %-70s" % [ pt.id, pt.descr ]
    end
else
    puts ProjectionType.list
end

