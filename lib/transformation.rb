module Proj
  class Transformation < PjObject
    def initialize(crs1, crs2)
      pointer = if crs1.is_a?(Crs) && crs2.is_a?(Crs)
                  Api.proj_create_crs_to_crs_from_pj(Context.current, crs1, crs2, nil, nil)
                else
                  Api.proj_create_crs_to_crs(Context.current, crs1, crs2, nil)
                end

      if pointer.null?
        Error.check
      end

      super(pointer)
    end

    def forward(coord)
      struct = Api.proj_trans(self, :PJ_FWD, coord)
      Coordinate.from_coord(struct)
    end

    def inverse(coord)
      struct = Api.proj_trans(self, :PJ_INV, coord)
      Coordinate.from_coord(struct)
    end
  end
end