# encoding: UTF-8

module Proj
  # Coordinate metadata is the information required to make coordinates unambiguous. For a
  # coordinate set referenced to a static CRS it is the CRS definition. For a
  # coordinate set referenced to a dynamic CRS it is the CRS definition together
  # with the coordinate epoch of the coordinates in the coordinate set.
  #
  # In a dynamic CRS, coordinates of a point on the surface of the Earth may change with time.
  # To be unambiguous the coordinates must always be qualified with the epoch at which they
  # are valid. The coordinate epoch is not necessarily the epoch at which the observation
  # was collected.
  class CoordinateMetadata < PjObject
    # Create a CoordinateMetadata object
    #
    # @param crs [Crs] The associated Crs
    # @param context [Context]. An optional Context
    # @param epoch [Double]. Epoch at wich the CRS is valid
    #
    # @return [CoordinateMetadata]
    def initialize(crs, context=nil, epoch=nil)
      ptr = Api.proj_coordinate_metadata_create(context || Context.current, crs, epoch)

      if ptr.null?
        Error.check_object(self)
      end

      super(ptr, context)
    end

    # Returns the coordinate epoch
    #
    # @return [Double]
    def epoch
      Api.proj_coordinate_metadata_get_epoch(self.context, self)
    end
  end
end
