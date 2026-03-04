# How-To Guides

Below is a list of guides that will show you how to achieve common tasks to get your day to day work done.

### Transformations

- [Geodetic to Projected Coordinates](examples/geodetic_to_projected.md) — transform lon/lat to easting/northing
- [Axis Order Normalization](examples/axis_order_normalization.md) — you'll hit this immediately
- [Transformation With Area Of Interest](examples/transformation_with_area.md) — refining operation selection
- [Operation Factory Context](examples/operation_factory_context.md) — advanced operation selection
- [Pipeline Operator](examples/pipeline_operator.md) — chaining steps
- [Batch Transformation](examples/batch_transformation.md) — doing it at scale

### Distance & Bounds

- [Geodesic Distance & Azimuth](examples/geodetic_distance.md) — distance and bearing between two points
- [Transforming Bounds](examples/transform_bounds.md) — transform a bounding box between CRS

### CRS & Database

- [CRS Identification](examples/crs_identification.md) — identify an unknown CRS against the database
- [Promote & Demote CRS to 3D](examples/promote_demote_3d.md) — add or remove a height axis
- [Database Querying](examples/database_query.md) — enumerate CRS entries from the PROJ database
- [Serialization Formats](examples/serialization_formats.md) — export CRS as WKT, PROJJSON, or PROJ string

### Debugging

- [Context Logging](examples/context_logging.md) — capture PROJ diagnostic messages

## Running

From the project root:

```console
ruby -Ilib lib/examples/geodetic_distance.rb
```

If PROJ data files are not discoverable in your environment, see [Configuration](configuration.md).
