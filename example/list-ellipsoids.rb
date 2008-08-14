#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

if ARGV[0] == '-v'
    puts "%-9s %-14s %-18s %-36s" % [ 'ID', 'a', 'b/rf', 'Name' ]
    puts '-----------------------------------------------------------------------------'
    Ellipsoid.list.sort.each do |ell|
        puts "%-9s %-14s %-18s %-36s" % [ ell.id, ell.major, ell.ell, ell.name ]
    end
else
    puts Ellipsoid.list.sort
end

