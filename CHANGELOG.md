# Changelog

## 5.0.0 - March 4, 2026
* Switch to auto-generated FFI bindings via [ruby-bindgen](https://github.com/cfis/ruby-bindgen)
* Add support for PROJ 9.4 API `proj_crs_has_point_motion_operation`
* Add support for PROJ 9.5 APIs: `proj_context_set_user_writable_directory`, `proj_coordoperation_requires_per_coordinate_input_time`, and `proj_create_conversion_local_orthographic`
* Add support for PROJ 9.6 APIs: `proj_trans_bounds_3D`
* Add support for PROJ 9.7 APIs: `proj_geod_direct`
* Add 3D bounds support (`Bounds3d` + `transform_bounds_3d`) for PROJ 9.6 `proj_trans_bounds_3D`
* Fix manual wrapper argument order for `proj_create_conversion_lambert_conic_conformal_1sp_variant_b` (9.4)
* Fix `Parameter#to_description` passing parameter name instead of unit name
* Fix pointer lifetime issues in `Parameters#types=`, `PjAxisDescription`, and `PjParamDescription`
* Fix GC lifetime bugs: option string pointers, `CoordinateSystem.create` axis descriptions, and missing `require 'uri'`
* Fix context/state lifetime issues in `OperationFactoryContext` and `Context#set_log_function`
* Expand regression tests for lifecycle safety and new PROJ 9.4/9.5/9.6 wrappers
* `Unit.built_in` now returns all unit types (91 units) instead of only linear units (24 units)
* Internal: struct and enum types use Ruby naming conventions (e.g., `PjCoord` instead of `PJ_COORD`)
* Remove deprecated `Context#database_path` and `Context#database_path=` (use `context.database.path` instead)
* Internal: method names use Ruby naming conventions (e.g., `proj_create_ellipsoidal_2d_cs` instead of `proj_create_ellipsoidal_2D_cs`)

## 4.1.1 - January 30, 2024
* Update tests for Proj 9.3
* Initial support for CoordinateMetadata in Proj 9.4 (not released yet)

## 4.1.0 - March 12, 2023
* Fix YARD warnings
* Fix YARD types to match RBS types
* Don't use type as attribute or method name to avoid conflicts with RBS

## 4.0.0 - March 12, 2023
* Support Proj 9
* Add support for missing APIs - the gem now provides almost 100% coverage
* Add support for Proj experimental APIs including the creation of projection conversions
* Add/updated support for a number of ISO 19111 classes, including PrimeMeridian, Ellipsoid, Datum, DatumEnsemble, CoordinateOperation and Parameters
* Greatly improved documentation (https://rubydoc.info/github/cfis/proj4rb)
* Remove old Proj 4.9 support
* Note this release does have some API changes. These include the removal of Proj 4.9 Point and Coordinate classes, changes to the PrimeMeridian class and changes to the Ellipsoid class. These changes should not impact most users.

## 3.0.0 - September 26, 2021
* Support Proj 8 which removes the old Proj API (Charlie Savage)
* Support newer versions of FFI which remove support for returning strings from callbacks (Charlie Savage)

## 2.2.2 - January 10, 2020
* Move proj_context_set_autoclose_database to api 6.2 (Jan Klimke)
* Improve search path generation code (Charlie Savage)

## 2.2.1 - January 8, 2020
* Move proj_as_projjson from version 6.0 to 6.2 api (Charlie Savage)
* Improve search path generation code (Charlie Savage)

## 2.2.0 - January 7, 2020
* Fix broken gem - was not including all api files (Jan Klimke)
* Add paths on MacOS when using Brew (Jan Klimke)
* Various code cleanups (Charlie Savage)

## 2.1.0 - January 5, 2020
* Set Ruby 2.4.1 to be the minimum allowed version (Samuel Williams)
* Fix incorrect use of context, reduce warnings when running tests (Samuel Williams)
* Fix `bundle exec rake test` (Samuel Williams)
* Add 2.4.1 to the travis test matrix (Samuel Williams)

## 2.0.0 - December 30, 2019
* Full rewrite to support API changes in Proj versions 5 and 6 (Charlie Savage)
* As part of rewrite switch bindings to use FFI versus a C extension (Charlie Savage)
* Split Ruby code into multiple files based on classes (Charlie Savage)
* Add in a bunch of new classes including Context, Crs, Coordinate, Ellipsoid, Prime Meridian and Transform (Charlie Savage)
* Deprecate Projection and Point - these will stop working with Proj 7 since they use an older deprecated API (Charlie Savage)

## 1.0.0 - December 14, 2014
* Calling this 1.0.0 since its a very stable gem (Charlie Savage)

## 0.4.3 - August 30, 2011
* Remove reference to now private projects.h header

## 0.4.2 - August 15, 2011
* Minor build tweak to support MSVC++

## 0.4.1 - July 30, 2011
* Search first for binaries when using windows gems
* Add # encoding to test files
* Reformat tests files to use standard ruby 2 space indenting

## 0.4.0 - July 30, 2011
* Update to compile on Ruby 1.9.* (Fabio Renzo Panettieri)
* Add in gemspec file (Charlie Savage)
* Add rake-compiler as development dependency, remove older MinGW build system (Charlie Savage)
* Move to GitHub (Charlie Savage)

## 0.3.1 - December 23, 2009
* Update extconf.conf file to be more flexible to make it easier to build on OS X when using MacPorts
* Updated windows binary to link against proj4.7

## 0.3.0 - August 14, 2008
* Removed Proj4::UV class which was previously deprecated
* New build infrastructure for Windows (Charlie Savage)
* Fixed memory leaks in forward() and inverse() methods (Charlie Savage)
