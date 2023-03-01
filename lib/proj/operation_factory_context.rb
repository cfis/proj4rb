module Proj
  # A context for building coordinate operations between two CRS.
  class OperationFactoryContext
    attr_reader :context

    def self.finalize(pointer)
      proc do
        Api.proj_operation_factory_context_destroy(pointer)
      end
    end

    # Create a new OperationFactoryContext
    #
    # @param authority - If authority is nil or the empty string, then coordinate operations
    #                    from any authority will be searched, with the restrictions set
    #                    in the authority_to_authority_preference database table.
    #                    If authority is set to "any", then coordinate operations from any
    #                    authority will be searched
    #                    If authority is a non-empty string different of "any", then coordinate
    #                    operations will be searched only in that authority namespace.
    # @param context   - The context to use or the current context if nil
    def initialize(authority = nil, context = nil)
      @context = context || Context.current
      @pointer = Api.proj_create_operation_factory_context(context, authority)
      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    # Find a list of CoordinateOperation from source_crs to target_crs
    #
    # @param source [Crs] Source CRS. Must not be nil.
    # @param target [Crs] Target CRS. Must not be nil.
    #
    # @return [Array] - Returns a list of operations
    def create_operations(source, target)
      ptr = Api.proj_create_operations(self.context, source, target, self)
      PjObjects.new(ptr, self.context)
    end

    # Specifies whether ballpark transformations are allowed.
    #
    # @param value - Set to True allow ballpark transformations otherwise False
    def ballpark_transformations=(value)
      Api.proj_operation_factory_context_set_allow_ballpark_transformations(self.context, self, value ? 1 : 0)
    end

    # Set the desired accuracy of the resulting coordinate transformations.
    #
    # @param value [double] - Accuracy in meters. Set to 0 to disable the filter.
    def desired_accuracy=(value)
      Api.proj_operation_factory_context_set_desired_accuracy(self.context, self, value)
    end

    # Set the desired area of interest for the resulting coordinate transformations. For an
    # area of interest crossing the anti-meridian, west_lon_degree will be greater than east_lon_degree.
    #
    # @param west  West longitude (in degrees).
    # @param south South latitude (in degrees).
    # @param east East longitude (in degrees).
    # @param north North latitude (in degrees).
    def set_area_of_interest(west, south, east, north)
      Api.proj_operation_factory_context_set_area_of_interest(self.context, self, west, south, east, north)
    end

    # Set the name of the desired area of interest for the resulting coordinate transformations.
    #
    # @param value - Name of the area. Must be known of the database.
    def area_of_interest_name=(value)
      Api.proj_operation_factory_context_set_area_of_interest_name(self.context, self, value)
    end

    # Set how source and target CRS extent should be used when considering if a transformation
    # can be used (only takes effect if no area of interest is explicitly defined).
    #
    # @param value [PROJ_CRS_EXTENT_USE] How source and target CRS extent should be used.
    def crs_extent_use=(value)
      Api.proj_operation_factory_context_set_crs_extent_use(self.context, self, value)
    end

    # Set the spatial criterion to use when comparing the area of validity of coordinate operations
    # with the area of interest / area of validity of source and target CRS.
    #
    #  @param value [PROJ_SPATIAL_CRITERION] spatial criterion to use
    def spatial_criterion=(value)
      Api.proj_operation_factory_context_set_spatial_criterion(self.context, self, value)
    end

    # Set how grid availability is used.
    #
    #  @param [PROJ_GRID_AVAILABILITY_USE] - Use how grid availability is used.
    def grid_availability=(value)
      Api.proj_operation_factory_context_set_grid_availability_use(self.context, self, value)
    end

    # Set whether PROJ alternative grid names should be substituted to the official authority names.
    #
    # @param value [boolean] - Whether PROJ alternative grid names should be used
    def use_proj_alternative_grid_names=(value)
      Api.proj_operation_factory_context_set_use_proj_alternative_grid_names(self.context, self, value ? 1 : 0)
    end

    # Set whether an intermediate pivot CRS can be used for researching coordinate operations
    # between a source and target CRS.
    #
    # @param value [PROJ_INTERMEDIATE_CRS_USE] - Whether and how intermediate CRS may be used
    def allow_use_intermediate_crs=(value)
      Api.proj_operation_factory_context_set_allow_use_intermediate_crs(self.context, self, value)
    end

    # Restrict the potential pivot CRSs that can be used when trying to build a coordinate operation
    # between two CRS that have no direct operation.
    #
    # @param values [Array] - Array of string with the format ["auth_name1", "code1", "auth_name2", "code2"]
    def allowed_intermediate_crs=(values)
      # Convert strings to C chars
      values_ptr = values.map do |value|
        FFI::MemoryPointer.from_string(value)
      end

      # Add extra item at end for null pointer
      pointer = FFI::MemoryPointer.new(:pointer, values.size + 1)
      pointer.write_array_of_pointer(values_ptr)

      Api.proj_operation_factory_context_set_allowed_intermediate_crs(self.context, self, pointer)
    end

    # Set whether transformations that are superseded (but not deprecated) should be discarded.
    #
    # @param value [bool] - Whether to discard superseded crses
    def discard_superseded=(value)
      Api.proj_operation_factory_context_set_discard_superseded(self.context, self, value ? 1 : 0)
    end

    def to_ptr
      @pointer
    end
  end
end