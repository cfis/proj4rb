#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

if ARGV[0] == '-v'
    puts "%-15s %-10s %-50s" % [ 'ID', 'Ellipse ID', 'Comment' ]
    puts '-----------------------------------------------------------------------------'
    Datum.list.sort.each do |datum|
        puts "%-15s %-10s %-50s\n  %s\n " % [ datum.id, datum.ellipse_id, datum.comments, datum.defn ]
    end
else
    puts Datum.list.sort
end

