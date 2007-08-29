#!/usr/bin/ruby -w

$:.unshift(File.dirname(__FILE__) + '/../lib/')

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

