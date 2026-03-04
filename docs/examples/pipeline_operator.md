# Pipeline Operator

The pipeline operator chains multiple steps into a single conversion. This is useful when you need to go through an intermediate representation — for example, converting between two projected coordinate systems that share the same datum but use different projections or units.

The example below converts California State Plane Zone VI coordinates from US survey feet to metres. Both steps use the same Lambert Conformal Conic (LCC) projection with the same parameters, but different units and false origins:

1. **Step 1** (`+inv`): Inverse LCC — unprojects from State Plane (US feet) back to geographic coordinates
2. **Step 2**: Forward LCC — reprojects to State Plane (metres)

```ruby
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

puts "Converted: x=#{to.x}, y=#{to.y}"
```

See `lib/example/pipeline_operator.rb`
