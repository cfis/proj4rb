# encoding: UTF-8
module Proj
  class CrsInfo
    attr_reader :auth_name, :code, :name, :type, :deprecated, :bbox_valid,
                :west_lon_degree, :south_lat_degree, :east_lon_degree, :north_lat_degree,
                :area_name, :projection_method_name, :celestial_body_name

    def self.from_proj_crs_info(proj_crs_info)
      data = {auth_name: proj_crs_info[:auth_name],
              code: proj_crs_info[:code],
              name: proj_crs_info[:name],
              type: proj_crs_info[:type],
              deprecated: proj_crs_info[:deprecated] == 1 ? true : false,
              bbox_valid: proj_crs_info[:bbox_valid] == 1 ? true : false,
              west_lon_degree: proj_crs_info[:west_lon_degree],
              south_lat_degree: proj_crs_info[:south_lat_degree],
              east_lon_degree: proj_crs_info[:east_lon_degree],
              north_lat_degree: proj_crs_info[:north_lat_degree],
              area_name: proj_crs_info[:area_name],
              projection_method_name: proj_crs_info[:projection_method_name]}

      if Api::PROJ_VERSION >= Gem::Version.new('8.1.0')
        data[:celestial_body_name] = proj_crs_info[:celestial_body_name]
      end

      new(**data)
    end

    def initialize(auth_name:, code:, name:, type:, deprecated:, bbox_valid:,
                   west_lon_degree:, south_lat_degree:, east_lon_degree:, north_lat_degree:,
                   area_name:, projection_method_name:, celestial_body_name: nil)
      @auth_name = auth_name
      @code = code
      @name = name
      @type = type
      @deprecated = deprecated
      @bbox_valid = bbox_valid
      @west_lon_degree = west_lon_degree
      @south_lat_degree = south_lat_degree
      @east_lon_degree = east_lon_degree
      @north_lat_degree = north_lat_degree
      @area_name = area_name
      @projection_method_name = projection_method_name
      @celestial_body_name = celestial_body_name
    end
  end
end
