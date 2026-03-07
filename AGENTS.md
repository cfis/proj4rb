# Agents Guide for proj4rb

## Project Overview
proj4rb provides Ruby bindings for the [Proj](https://proj.org) coordinate transformation library using FFI. It supports Proj versions 4 through 9.x.

## Architecture
- **FFI-based**: Uses the `ffi` gem to bind to the native `libproj` shared library. No C extensions.
- **Dynamic loading**: Code is loaded dynamically based on the installed Proj version (see `lib/api/`).
- **Class hierarchy** mirrors the Proj/OGC model:
  - `PjObject` is the base class
  - `Crs`, `Conversion`, `Transformation`, `Datum`, `Ellipsoid`, `PrimeMeridian`, `CoordinateSystem`, etc. are subclasses
  - `CoordinateOperationMixin` is shared by `Conversion` and `Transformation`

## Key Directories
- `lib/proj.rb` / `lib/proj4.rb` — Entry points (`require 'proj'` or `require 'proj4'`)
- `lib/api/` — FFI bindings to native Proj C functions, organized by version
- `lib/proj/` — Ruby wrapper classes (Crs, Transformation, Context, Coordinate, etc.)
- `test/` — Minitest test suite (`test/*_test.rb`)

## Development

### Dependencies
```
gem install bundler
bundle install
```

### Running Tests
```
bundle exec rake test
```
Tests use Minitest. Test files follow the pattern `test/*_test.rb` and inherit from `AbstractTest` in `test/abstract_test.rb`.

### Building the Gem
```
rake package
```

### Generating Docs
```
rake yard
```

## Environment Variables
- `PROJ_LIB_PATH` — Override the path to the `libproj` shared library
- `PROJ_DATA` — Path to the folder containing `proj.db` (Proj 6+). Must be set before Ruby launches.

## Updating for New PROJ Releases

When a new PROJ version is released, update `ffi-bindings.yaml` to include any new API functions. Here's the process:

### 1. Identify new functions

Compare `proj.h` between the last supported version and the new release on GitHub:

```
https://raw.githubusercontent.com/OSGeo/PROJ/<VERSION>/src/proj.h
```

Extract all `proj_*` function declarations from each version and diff them. New functions are those present in the new version but absent in the previous one. Only minor releases (e.g., 9.5.0, 9.6.0) typically add new API functions — patch releases (e.g., 9.5.1) generally do not.

### 2. Check SO version

Check whether `PROJ_SOVERSION` changed in `CMakeLists.txt`:

```
https://raw.githubusercontent.com/OSGeo/PROJ/<VERSION>/CMakeLists.txt
```

If it changed, add the new SO version string to the `library_versions` list in `ffi-bindings.yaml`.

### 3. Add version guard entries

Add a new section under `symbols.versions` in `ffi-bindings.yaml` using the PROJ version number macro format (`major * 10000 + minor * 100 + patch`):

```yaml
    # 9.8.0
    90800:
      - proj_new_function_name
```

### 4. Regenerate bindings

Run ruby-bindgen to regenerate the FFI bindings:

```
bundle exec ruby-bindgen ffi-bindings.yaml
```

### 5. Version detection

Version guards in the generated bindings call `proj_version`, a method defined in `lib/api/proj_version.rb`. This file is user-maintained (not overwritten by ruby-bindgen) and reads the runtime library version via `proj_info`. No manual fixes are needed after regeneration.

### Version number format

PROJ version numbers are computed as `major * 10000 + minor * 100 + patch`. Examples:
- 5.0.0 → 50000 (baseline, no version guard)
- 6.0.0 → 60000
- 9.4.0 → 90400
- 9.7.0 → 90700

## GitHub CLI
- `gh` is available and authenticated with READ-ONLY access
- DO NOT use `gh` to create, update, or modify anything (no PRs, issues, comments, releases, etc.)
- Use `gh` only to read information: view CI runs, check PR status, read issues, etc.

## Conventions
- Namespace: `Proj::` (e.g., `Proj::Crs`, `Proj::Transformation`, `Proj::Coordinate`)
- Legacy namespace `Proj4::` is supported via `require 'proj4'`
- License: MIT
- Ruby version: >= 2.7
- Commits must not include a co-author or author line (no `Co-Authored-By`)
- Tests must not use mocks or stubs. Always call the real PROJ C API.
- **Never manually edit auto-generated files** (`lib/api/proj.rb`, `lib/api/proj_experimental.rb`). Fix issues in `ffi-bindings.yaml` and regenerate instead.
