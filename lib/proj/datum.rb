module Proj
  class Datum < PjObject
    # Returns the frame reference epoch of a dynamic geodetic or vertical reference frame
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_dynamic_datum_get_frame_reference_epoch
    #
    # @return [Double] The frame reference epoch as decimal year, or -1 in case of error.
    def frame_reference_epoch
      Api.proj_dynamic_datum_get_frame_reference_epoch(self.context, self)
    end

    # Return the ellipsoid
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_ellipsoid
    #
    # @return [PjObject]
    def ellipsoid
      ptr = Api.proj_get_ellipsoid(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the prime meridian
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_prime_meridian
    #
    # @return [PjObject]
    def prime_meridian
      ptr = Api.proj_get_prime_meridian(self.context, self)
      PjObject.create_object(ptr, self.context)
    end
  end
end
