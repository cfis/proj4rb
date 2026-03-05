# Promote & Demote CRS to 3D

Most common CRS definitions like EPSG:4326 (WGS 84) are 2D — they only define latitude and longitude. But if your data includes elevation (GPS heights, LiDAR, aviation), you need a 3D CRS that adds a height axis. Rather than looking up a separate 3D EPSG code, you can promote any 2D CRS to 3D programmatically. You can also demote a 3D CRS back to 2D when you want to discard the height component.

```ruby
crs_2d = Proj::Crs.new('EPSG:4326')
puts crs_2d.proj_type  #=> PJ_TYPE_GEOGRAPHIC_2D_CRS

# Promote to 3D
crs_3d = crs_2d.promote_to_3d
puts crs_3d.proj_type  #=> PJ_TYPE_GEOGRAPHIC_3D_CRS

# Demote back to 2D
crs_back = crs_3d.demote_to_2d
puts crs_back.proj_type  #=> PJ_TYPE_GEOGRAPHIC_2D_CRS
```

The promoted CRS adds an ellipsoidal height axis oriented upwards with metre units.

See [lib/examples/promote_demote_3d.rb](https://github.com/cfis/proj4rb/blob/master/lib/examples/promote_demote_3d.rb)
