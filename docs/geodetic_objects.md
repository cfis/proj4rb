# Geodetic Objects

Geodetic objects are the building blocks of coordinate reference systems. An ellipsoid models the Earth's shape, a datum ties that model to the real Earth, and a prime meridian defines where longitude starts. For background on how these fit together, see [Geodetic Coordinate Systems](https://cfis.savagexi.com/2006/04/29/geodetic-coordinate-systems/).

proj4rb provides classes for each: `Ellipsoid`, `Datum`, `DatumEnsemble`, and `PrimeMeridian`.

## Ellipsoid

An `Ellipsoid` defines the shape of the Earth (or other celestial body) used by a CRS.

### Built-in Ellipsoids

```ruby
ellipsoids = Proj::Ellipsoid.built_in
ellipsoids.each do |ellipsoid|
  puts "#{ellipsoid[:id]} - #{ellipsoid[:name]}"
end
```

### From a CRS

```ruby
crs = Proj::Crs.new('EPSG:4326')
ellipsoid = crs.ellipsoid

puts ellipsoid.name                  # "WGS 84"
puts ellipsoid.semi_major_axis       # 6378137.0
puts ellipsoid.semi_minor_axis       # 6356752.314245179
puts ellipsoid.inverse_flattening    # 298.257223563
```

### From the Database

```ruby
ellipsoid = Proj::PjObject.create_from_database("EPSG", "7030", :PJ_CATEGORY_ELLIPSOID)
puts ellipsoid.name    # "WGS 84"
```

## Datum

A `Datum` (geodetic reference frame) defines the relationship between a coordinate system and the Earth.

### From a CRS

```ruby
crs = Proj::Crs.new('EPSG:4326')
datum = crs.datum

puts datum.name    # "World Geodetic System 1984"
```

### Dynamic Datums

For dynamic geodetic reference frames, you can query the frame reference epoch:

```ruby
datum = crs.datum
puts datum.frame_reference_epoch    # e.g., 2010.0
```

### Accessing Related Objects

```ruby
datum = crs.datum
puts datum.ellipsoid.name        # "WGS 84"
puts datum.prime_meridian.name   # "Greenwich"
```

## Datum Ensemble

Modern CRS definitions may use a `DatumEnsemble` instead of a single datum. This groups multiple datums that are considered equivalent within a given accuracy.

```ruby
crs = Proj::Crs.new('EPSG:4326')
ensemble = crs.datum_ensemble

if ensemble
  puts ensemble.accuracy    # Positional accuracy in meters
  puts ensemble.count       # Number of member datums

  ensemble.count.times do |i|
    member = ensemble[i]
    puts member.name
  end
end
```

## Prime Meridian

A `PrimeMeridian` defines the origin of longitude.

### Built-in Prime Meridians

```ruby
meridians = Proj::PrimeMeridian.built_in
meridians.each do |pm|
  puts "#{pm[:id]} - #{pm[:defn]}"
end
```

### From a CRS

```ruby
crs = Proj::Crs.new('EPSG:4326')
pm = crs.prime_meridian

puts pm.name             # "Greenwich"
puts pm.longitude        # 0.0
puts pm.unit_name        # "degree"
puts pm.unit_conv_factor # 0.017453292519943295
```

## Coordinate System

A `CoordinateSystem` describes the axes of a CRS including their names, directions, and units.

```ruby
crs = Proj::Crs.new('EPSG:4326')
cs = crs.coordinate_system

puts cs.cs_type     # :PJ_CS_TYPE_ELLIPSOIDAL
puts cs.axis_count  # 2

cs.axis_count.times do |i|
  axis = cs.axis_info(i)
  puts "#{axis.name}: #{axis.direction} (#{axis.unit_name})"
end
```
