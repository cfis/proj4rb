module Proj
  # Transformation objects convert {Coordinate Coordinates} from one {Crs} to another.
  class Transformation < PjObject
    # Transforms a {Coordinate} from the source {Crs} to the target {Crs}. Coordinates should be expressed in
    # the units and axis order of the definition of the source CRS. The returned transformed coordinate will
    # be in the units and axis order of the definition of the target CRS.
    #
    # For most geographic Crses, the units will be in degrees. For geographic CRS defined by the EPSG authority,
    # the order of coordinates is latitude first, longitude second. When using a PROJ initialization string,
    # on contrary, the order will be longitude first, latitude second.
    #
    # For projected CRS, the units may vary (metre, us-foot, etc..).
    #
    # For projected CRS defined by the EPSG authority, and with EAST / NORTH directions, the axis order might be
    # easting first, northing second, or the reverse. When using a PROJ string, the order will be
    # easting first, northing second, except if the +axis parameter modifies it.
    #
    # @param source [Crs | String] - The source Crs. See the Crs documentation for the string format
    # @param target [Crs | String] - The target Crs. See the Crs documentation for the string format
    # @param context [Context]
    def initialize(source, target, context=nil)
      pointer = if source.is_a?(Crs) && target.is_a?(Crs)
                  if Api.method_defined?(:proj_create_crs_to_crs_from_pj)
                    Api.proj_create_crs_to_crs_from_pj(context, source, target, nil, nil)
                  else
                    Api.proj_create_crs_to_crs(context, source.definition, target.definition, nil)
                  end
                else
                  Api.proj_create_crs_to_crs(context, source, target, nil)
                end

      if pointer.null?
        Error.check
      end

      super(pointer, context)
    end

    # Transforms a {Coordinate} from the source {Crs} to the target {Crs}. Coordinates should be expressed in
    # the units and axis order of the definition of the source CRS. The returned transformed coordinate will
    # be in the units and axis order of the definition of the target CRS.
    #
    # @param coord [Coordinate]
    # @return [Coordinate]
    def forward(coord)
      struct = Api.proj_trans(self, :PJ_FWD, coord)
      Coordinate.from_coord(struct)
    end

    # Transforms a {Coordinate} from the target {Crs} to the source {Crs}. Coordinates should be expressed in
    # the units and axis order of the definition of the source CRS. The returned transformed coordinate will
    # be in the units and axis order of the definition of the target CRS.
    #
    # @param coord [Coordinate]
    # @return [Coordinate]
    def inverse(coord)
      struct = Api.proj_trans(self, :PJ_INV, coord)
      Coordinate.from_coord(struct)
    end
  end
end