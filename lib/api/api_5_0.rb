module Proj
  module Api
    typedef :pointer, :PJ
    typedef :pointer, :PJ_CONTEXT
    typedef :pointer, :PJ_AREA

    class PJ_FACTORS < FFI::Struct
      layout :meridional_scale, :double,               # h 
             :parallel_scale, :double,                 # k 
             :areal_scale, :double,                    # s 
         
             :angular_distortion, :double,             # omega 
             :meridian_parallel_angle, :double,        # theta-prime 
             :meridian_convergence, :double,           # alpha 
        
             :tissot_semimajor, :double,               # a 
             :tissot_semiminor, :double,               # b 
         
             :dx_dlam, :double,
             :dx_dphi, :double,
             :dy_dlam, :double,
             :dy_dphi, :double
    end

    # Data types for list of operations, ellipsoids, datums and units used in PROJ.4
    class PJ_LIST < FFI::Struct
      layout :id,    :string,   # projection keyword
             :PJ,    :pointer,  # projection entry point
             :descr, :pointer   # description text
    end

    class PJ_ELLPS < FFI::Struct
      layout :id, :string, # ellipse keyword name
             :major, :string, # a= value
             :ell, :string, # elliptical parameter
             :name, :string # comments
    end

    class PJ_UNITS < FFI::Struct
      layout :id, :string, # units keyword
             :to_meter, :string, # multiply by value to get meters
             :name, :string, # comments
             :factor, :double # to_meter factor in actual numbers
    end

    class PJ_PRIME_MERIDIANS < FFI::Struct
      layout :id, :string, # prime meridian keyword
             :defn, :string # offset from greenwich in DMS format.
    end

    # Geodetic, mostly spatiotemporal coordinate types
    class PJ_XYZT < FFI::Struct
      layout :x, :double,
             :y, :double,
             :z, :double,
             :t, :double
    end

    class PJ_UVWT < FFI::Struct
      layout :u, :double,
             :v, :double,
             :w, :double,
             :t, :double
    end

    class PJ_LPZT < FFI::Struct
      layout :lam, :double,
             :phi, :double,
             :z, :double,
             :t, :double
    end

    # Rotations: omega, phi, kappa
    class PJ_OPK < FFI::Struct
      layout :o, :double,
             :p, :double,
             :k, :double
    end

    # East, North, Up
    class PJ_ENU < FFI::Struct
      layout :e, :double,
             :n, :double,
             :u, :double
    end

    # Geodesic length, fwd azi, rev azi
    class PJ_GEOD < FFI::Struct
      layout :s, :double,
             :a1, :double,
             :a2, :double
    end

    # Classic proj.4 pair/triplet types - moved into the PJ_ name space.
    class PJ_UV < FFI::Struct
      layout :u, :double,
             :v, :double
    end

    class PJ_XY < FFI::Struct
      layout :x, :double,
             :y, :double
    end

    class PJ_LP < FFI::Struct
      layout :lam, :double,
             :phi, :double
    end

    class PJ_XYZ < FFI::Struct
      layout :x, :double,
             :y, :double,
             :z, :double
    end

    class PJ_UVW < FFI::Struct
      layout :u, :double,
             :v, :double,
             :w, :double
    end

    class PJ_LPZ < FFI::Struct
      layout :lam, :double,
             :phi, :double,
             :z, :double
    end

    class PJ_COORD < FFI::Union
      layout :v, [:double, 4],
             :xyzt, PJ_XYZT,
             :uvwt, PJ_UVWT,
             :lpzt, PJ_LPZT,
             :geod, PJ_GEOD,
             :opk, PJ_OPK,
             :enu, PJ_ENU,
             :xyz, PJ_XYZ,
             :uvw, PJ_UVW,
             :lpz, PJ_LPZ,
             :xy,  PJ_XY,
             :uv, PJ_UV,
             :lp, PJ_LP

      def eql?(other)
        self[:v][0] == other[:v][0] &&
        self[:v][1] == other[:v][1] &&
        self[:v][2] == other[:v][2] &&
        self[:v][3] == other[:v][3]
      end

      def ==(other)
        self.eql?(other)
      end
    end

    class PJ_INFO < FFI::Struct
      layout :major, :int, # Major release number
             :minor, :int,  # Minor release number
             :patch, :int,  # Patch level
             :release, :string,  # Release info. Version + date
             :version, :string,   # Full version number
             :searchpath, :string,  # Paths where init and grid files are looked for. Paths are separated by
                                    # semi-colons on Windows, and colons on non-Windows platforms.
             :paths, :pointer,
             :path_count, :size_t
    end

    class PJ_PROJ_INFO < FFI::Struct
      layout :id, :string, # Name of the projection in question
             :description, :string, # Description of the projection
             :definition, :string, # Projection definition
             :has_inverse, :int, # 1 if an inverse mapping exists, 0 otherwise
             :accuracy, :double # Expected accuracy of the transformation. -1 if unknown.

      def to_s
        "<#{self.class.name} id: #{self[:id]},  description: #{self[:description]}, definition: #{self[:definition]}, has_inverse: #{self[:has_inverse]} accuracy: #{self[:accuracy]}"
      end
    end

    class PJ_GRID_INFO < FFI::Struct
      layout :gridname, [:char, 32],  # name of grid
             :filename, [:char, 260], # full path to grid
             :format, [:char, 8],     # file format of grid
             :lowerleft, PJ_LP,         # Coordinates of lower left corner
             :upperright, PJ_LP,        # Coordinates of upper right corner
             :n_lon, :int,              # Grid size
             :n_lat, :int,              # Grid size
             :cs_lon, :double,          # Cell size of grid
             :cs_lat, :double           # Cell size of grid
    end

    class PJ_INIT_INFO < FFI::Struct
      layout :name, [:string, 32],       # name init file
             :filename, [:string, 260],  # full path to the init file
             :version, [:string, 32],    # version of the init file
             :origin, [:string, 32],     # origin of the file, e.g. EPSG
             :lastupdate, [:string, 16] # Date of last update in YYYY-MM-DD format
    end

    # @return [Symbol]
    PJ_LOG_LEVEL = enum(:PJ_LOG_NONE , 0,
                        :PJ_LOG_ERROR, 1,
                        :PJ_LOG_DEBUG, 2,
                        :PJ_LOG_TRACE, 3,
                        :PJ_LOG_TELL , 4,
                        :PJ_LOG_DEBUG_MAJOR, 2, # for proj_api.h compatibility
                        :PJ_LOG_DEBUG_MINOR, 3) # for proj_api.h compatibility

    # Apply transformation to observation - in forward or inverse direction
    # @return [Symbol]
    PJ_DIRECTION = enum(:PJ_FWD, 1,   # Forward
                        :PJ_IDENT, 0, # Do nothing
                        :PJ_INV, -1)  # Inverse

    # Object category
    # @return [Symbol]
    PJ_CATEGORY = enum(:PJ_CATEGORY_ELLIPSOID,
                       :PJ_CATEGORY_PRIME_MERIDIAN,
                       :PJ_CATEGORY_DATUM,
                       :PJ_CATEGORY_CRS,
                       :PJ_CATEGORY_COORDINATE_OPERATION,
                       :PJ_CATEGORY_DATUM_ENSEMBLE)

    # @return [Symbol]
    PJ_TYPE = enum(:PJ_TYPE_UNKNOWN,
                   :PJ_TYPE_ELLIPSOID,
                   :PJ_TYPE_PRIME_MERIDIAN,
                   :PJ_TYPE_GEODETIC_REFERENCE_FRAME,
                   :PJ_TYPE_DYNAMIC_GEODETIC_REFERENCE_FRAME,
                   :PJ_TYPE_VERTICAL_REFERENCE_FRAME,
                   :PJ_TYPE_DYNAMIC_VERTICAL_REFERENCE_FRAME,
                   :PJ_TYPE_DATUM_ENSEMBLE,

                   # Abstract type, not returned by proj_get_type()
                   :PJ_TYPE_CRS,

                   :PJ_TYPE_GEODETIC_CRS,
                   :PJ_TYPE_GEOCENTRIC_CRS,
                   :PJ_TYPE_GEOGRAPHIC_CRS,
                   :PJ_TYPE_GEOGRAPHIC_2D_CRS,
                   :PJ_TYPE_GEOGRAPHIC_3D_CRS,
                   :PJ_TYPE_VERTICAL_CRS,
                   :PJ_TYPE_PROJECTED_CRS,
                   :PJ_TYPE_COMPOUND_CRS,
                   :PJ_TYPE_TEMPORAL_CRS,
                   :PJ_TYPE_ENGINEERING_CRS,
                   :PJ_TYPE_BOUND_CRS,
                   :PJ_TYPE_OTHER_CRS,

                   :PJ_TYPE_CONVERSION,
                   :PJ_TYPE_TRANSFORMATION,
                   :PJ_TYPE_CONCATENATED_OPERATION,
                   :PJ_TYPE_OTHER_COORDINATE_OPERATION,

                   :PJ_TYPE_TEMPORAL_DATUM,
                   :PJ_TYPE_ENGINEERING_DATUM,
                   :PJ_TYPE_PARAMETRIC_DATUM,

                   :PJ_TYPE_DERIVED_PROJECTED_CRS,

                   :PJ_TYPE_COORDINATE_METADATA)

    # @return [Symbol]
    PJ_PROJ_STRING_TYPE = enum(:PJ_PROJ_5,
                               :PJ_PROJ_4)

    # @return [Symbol]
    PJ_COORDINATE_SYSTEM_TYPE = enum(:PJ_CS_TYPE_UNKNOWN,
                                     :PJ_CS_TYPE_CARTESIAN,
                                     :PJ_CS_TYPE_ELLIPSOIDAL,
                                     :PJ_CS_TYPE_VERTICAL,
                                     :PJ_CS_TYPE_SPHERICAL,
                                     :PJ_CS_TYPE_ORDINAL,
                                     :PJ_CS_TYPE_PARAMETRIC,
                                     :PJ_CS_TYPE_DATETIMETEMPORAL,
                                     :PJ_CS_TYPE_TEMPORALCOUNT,
                                     :PJ_CS_TYPE_TEMPORALMEASURE)

    # @return [Symbol]
    PJ_WKT_TYPE = enum(:PJ_WKT2_2015,
                       :PJ_WKT2_2015_SIMPLIFIED,
                       :PJ_WKT2_2019,
                       :PJ_WKT2_2018, # Deprecated alias for PJ_WKT2_2019
                       :PJ_WKT2_2018_SIMPLIFIED, # Deprecated alias for PJ_WKT2_2019
                       :PJ_WKT1_GDAL,
                       :PJ_WKT1_ESRI)

    attach_function :proj_info, [], PJ_INFO.by_value
    attach_function :proj_grid_info, [:string], PJ_GRID_INFO.by_value
    attach_function :proj_init_info, [:string], PJ_INIT_INFO.by_value

    attach_function :proj_pj_info, [:PJ], PJ_PROJ_INFO.by_value

    # Contexts
    attach_function :proj_context_create, [], :PJ_CONTEXT
    attach_function :proj_context_destroy, [:PJ_CONTEXT], :PJ_CONTEXT

    # Error handling
    attach_function :proj_context_errno, [:PJ_CONTEXT], :int
    attach_function :proj_errno, [:PJ], :int
    attach_function :proj_errno_set, [:PJ, :int], :int
    attach_function :proj_errno_reset, [:PJ], :int
    attach_function :proj_errno_restore, [:PJ, :int], :int

    # Manage the transformation definition object PJ
    attach_function :proj_create, [:PJ_CONTEXT, :string], :PJ
    attach_function :proj_create_argv, [:PJ_CONTEXT, :int, :pointer], :PJ
    attach_function :proj_create_crs_to_crs, [:PJ_CONTEXT, :string, :string, :PJ_AREA], :PJ
    attach_function :proj_destroy, [:PJ], :PJ

    attach_function :proj_trans, [:PJ, PJ_DIRECTION, PJ_COORD.by_value], PJ_COORD.by_value
    attach_function :proj_trans_generic, [:PJ, PJ_DIRECTION, :pointer, :size_t, :size_t, :pointer, :size_t, :size_t, :pointer, :size_t, :size_t, :pointer, :size_t, :size_t], :size_t
    attach_function :proj_trans_array, [:PJ, PJ_DIRECTION, :size_t, :pointer], :int
    attach_function :proj_roundtrip, [:PJ, PJ_DIRECTION, :int, PJ_COORD.by_ref], :double
    attach_function :proj_factors, [:PJ, PJ_COORD.by_value], PJ_FACTORS.by_value

    # Get lists of operations, ellipsoids, units and prime meridians
    attach_function :proj_list_operations, [], :pointer #PJ_LIST
    attach_function :proj_list_ellps, [], :pointer #PJ_ELLPS
    attach_function :proj_list_units, [], :pointer #PJ_UNITS
    attach_function :proj_list_prime_meridians, [], :pointer #PJ_PRIME_MERIDIANS

    # Degrees/radians
    attach_function :proj_torad, [:double], :double
    attach_function :proj_todeg, [:double], :double
    attach_function :proj_dmstor, [:string, :pointer], :double
    attach_function :proj_rtodms, [:pointer, :double, :int, :int], :string

    attach_function :proj_angular_input, [:PJ, PJ_DIRECTION], :int
    attach_function :proj_angular_output, [:PJ, PJ_DIRECTION], :int

    # Distances
    attach_function :proj_lp_dist, [:PJ, PJ_COORD.by_value, PJ_COORD.by_value], :double
    attach_function :proj_lpz_dist, [:PJ, PJ_COORD.by_value, PJ_COORD.by_value], :double
    attach_function :proj_geod, [:PJ, PJ_COORD.by_value, PJ_COORD.by_value], PJ_COORD.by_value
    attach_function :proj_xy_dist, [PJ_COORD.by_value, PJ_COORD.by_value], :double
    attach_function :proj_xyz_dist, [PJ_COORD.by_value, PJ_COORD.by_value], :double
  end
end