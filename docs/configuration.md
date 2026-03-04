# Configuration

proj4rb needs to locate both the PROJ shared library and its data files. In most cases this works automatically, but if PROJ is installed in a non-standard location you may need to set environment variables.

## Finding the Proj Library (PROJ_LIB_PATH)

proj4rb searches well-known locations for the `libproj` shared library. Override this by setting the `PROJ_LIB_PATH` environment variable to the full path to the library.

## Finding Proj Data Files (PROJ_DATA)

Starting with version 6, Proj stores its information (datums, ellipsoids, prime meridians, coordinate systems, units, etc.) in a sqlite file called `proj.db`. If Proj cannot find its database, an exception is raised. Set the `PROJ_DATA` environment variable to the folder containing `proj.db`.

Note: `PROJ_DATA` must be set before Ruby launches.

For more information see [proj.org/resource_files](https://proj.org/resource_files.html).

## Version-Gated APIs

Some APIs are only available when linked against a sufficiently new PROJ runtime. Check the runtime version with `Proj::Api::PROJ_VERSION`:

```ruby
if Proj::Api::PROJ_VERSION >= Gem::Version.new("9.6.0")
  # call 9.6+ APIs
end
```

Recent examples:

- `>= 9.4.0`: `Crs#point_motion_operation?`
- `>= 9.5.0`: `Context#set_user_writable_directory`, `Projection.local_orthographic`, `CoordinateOperationMixin#requires_per_coordinate_input_time?`
- `>= 9.6.0`: `Bounds3d`, `CoordinateOperationMixin#transform_bounds_3d`
