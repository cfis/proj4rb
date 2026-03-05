# frozen_string_literal: true

require 'proj'

conversion = Proj::Conversion.new(<<~EOS)
  +proj=pipeline
  +step +inv +proj=lcc +lat_1=33.88333333333333
  +lat_2=32.78333333333333 +lat_0=32.16666666666666
  +lon_0=-116.25 +x_0=2000000.0001016 +y_0=500000.0001016001 +ellps=GRS80
  +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs
  +step +proj=lcc +lat_1=33.88333333333333 +lat_2=32.78333333333333 +lat_0=32.16666666666666
  +lon_0=-116.25 +x_0=2000000 +y_0=500000
  +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs
EOS

from = Proj::Coordinate.new(x: 4_760_096.421921, y: 3_744_293.729449)
to = conversion.forward(from)

raise 'pipeline conversion failed' unless to.x.finite? && to.y.finite?

puts "ok: converted x=#{to.x}, y=#{to.y}"
