module Proj
  class GridInfo
    attr_reader :gridname, :filename, :format,
                :lower_left, :upper_right,
                :size_lon, :size_lat, :cell_size_lon, :cell_size_lat

    def initialize(pj_grid_info)
      @filename = pj_grid_info[:filename].to_ptr.read_string
      @gridname = pj_grid_info[:gridname].to_ptr.read_string
      @format = pj_grid_info[:format].to_ptr.read_string
      @lower_left = pj_grid_info[:lowerleft]
      @upper_right = pj_grid_info[:upperright]
      @size_lon = pj_grid_info[:n_lon]
      @size_lat = pj_grid_info[:n_lat]
      @cell_size_lon = pj_grid_info[:cs_lon]
      @cell_size_lat = pj_grid_info[:cs_lat]
    end
  end
end
