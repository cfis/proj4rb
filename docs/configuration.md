# Configuration

## Finding the Proj Library (PROJ_LIB_PATH)

proj4rb searches well-known locations for the `libproj` shared library. Override this by setting the `PROJ_LIB_PATH` environment variable to the full path to the library.

## Finding Proj Data Files (PROJ_DATA)

Starting with version 6, Proj stores its information (datums, ellipsoids, prime meridians, coordinate systems, units, etc.) in a sqlite file called `proj.db`. If Proj cannot find its database, an exception is raised. Set the `PROJ_DATA` environment variable to the folder containing `proj.db`.

Note: `PROJ_DATA` must be set before Ruby launches.

For more information see [proj.org/resource_files](https://proj.org/resource_files.html).

## Development

### Running Tests

proj4rb ships with a full test suite designed for Proj 6+.

```console
bundle exec rake test
```

### Building the Gem

```console
rake package
```

### Generating API Docs

```console
rake yard
```
