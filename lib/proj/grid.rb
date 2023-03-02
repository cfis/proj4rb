module Proj
  class Grid
    attr_reader :name, :full_name, :package_name, :url, :downloadable, :open_license, :available

    def initialize(name:, full_name:, package_name:, url:, downloadable:, open_license:, available:)
      @name = name
      @full_name = full_name
      @package_name = package_name
      @url = url
      @downloadable = downloadable
      @open_license = open_license
      @available = available
    end

    def info
      Api.proj_grid_info(self.name)
    end
  end
end
