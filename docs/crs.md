# Coordinate Reference Systems

To create a coordinate reference system, you can use CRS codes, well-known text (WKT) strings or old-style Proj strings (which are deprecated):

```ruby
crs1 = Proj::Crs.new('EPSG:4326')

crs2 = Proj::Crs.new('urn:ogc:def:crs:EPSG::4326')

crs3 = Proj::Crs.new('+proj=longlat +datum=WGS84 +no_defs +type=crs')

crs4 = Proj::Crs.new(<<~EOS)
  GEOGCRS["WGS 84",
  DATUM["World Geodetic System 1984",
        ELLIPSOID["WGS 84",6378137,298.257223563,
                  LENGTHUNIT["metre",1]]],
  PRIMEM["Greenwich",0,
         ANGLEUNIT["degree",0.0174532925199433]],
  CS[ellipsoidal,2],
  AXIS["geodetic latitude (Lat)",north,
       ORDER[1],
       ANGLEUNIT["degree",0.0174532925199433]],
  AXIS["geodetic longitude (Lon)",east,
       ORDER[2],
       ANGLEUNIT["degree",0.0174532925199433]],
  USAGE[
      SCOPE["unknown"],
          AREA["World"],
      BBOX[-90,-180,90,180]],
  ID["EPSG",4326]]
EOS
```

Notice when using the old-style Proj4 string, the addition of the `+type=crs` value.

## Axis Order

By default transformations accept coordinates in the units and axis order of the source CRS and return transformed coordinates in the units and axis order of the target CRS.

For most geographic CRS definitions, the units will be in degrees. For geographic CRS definitions from EPSG, the order is latitude then longitude.

For projected CRS definitions, the units vary (metre, us-foot, etc.). For projected CRS definitions from EPSG with EAST/NORTH directions, the order may be east then north, or north then east.

If you prefer a uniform axis order regardless of the source and target CRS objects, call `normalize_for_visualization`:

```ruby
normalized = transform.normalize_for_visualization
```

The normalized transformation will return longitude/latitude order for geographic CRS objects and easting/northing for most projected CRS objects.

For more information see [proj.org/faq](https://proj.org/faq.html#why-is-the-axis-ordering-in-proj-not-consistent).
