#!/usr/bin/ruby -w

$: << File.dirname(__FILE__) + '/../lib/' << File.dirname(__FILE__) + '/../ext/'

require 'proj4'
include Proj4

Error.list.collect{ |e| e + 'Error' }.each_with_index do |error, index|
    puts "%2d %s" % [index, error]
end

