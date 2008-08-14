#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'

puts Proj4::LIBVERSION

