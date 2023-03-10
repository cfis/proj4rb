module Proj
  # Grids define models that are used to perform dimension shifts.
  #
  # Grid files can be quite large and may not be included with Proj depending on how
  # it was packaged and any grid licensing requirements. Therefore, Proj has the ability
  # to download grids on the fly if {Context#network_enabled? networking} is enabled.
  #
  # @see https://proj.org/community/rfc/rfc-4.html#rfc4
  class Grid
    # @!attribute [r] context
    #   @return [Context] The grid context
    # @!attribute [r] name
    #   @return [String] The grid's name
    # @!attribute [r] full_name
    #   @return [String] The grid's full name
    # @!attribute [r] package_name
    #   @return [String] The grid's package name
    # @!attribute [r] url
    #   @return [URI] A url that can be used to download the grid
    attr_reader :context, :name, :full_name, :package_name, :url

    def initialize(name, context = Context.default, full_name: nil, package_name: nil, url: nil,
                   downloadable: false, open_license: false, available: false)
      @name = name
      @context = context
      @full_name = full_name
      @package_name = package_name
      @url = url
      @downloadable = downloadable
      @open_license = open_license
      @available = available
    end

    # Returns whether the grid can be downloaded
    #
    # @return [Boolean]
    def downloadable?
      @downloadable
    end

    # Returns whether the grid is released with an open license
    #
    # @return [Boolean]
    def open_license?
      @open_license
    end

    # Returns whether the grid is available at runtime
    #
    # @return [Boolean]
    def available?
      @available
    end

    # Returns information about this grid
    #
    # See https://proj.org/development/reference/functions.html#c.proj_grid_info proj_grid_info
    #
    # @return [GridInfo]
    def info
      ptr = Api.proj_grid_info(self.name)
      GridInfo.new(ptr)
    end

    # Returns if a grid is available in the PROJ user-writable directory.
    # This method will only return true if Context#network_enabled? is true
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_is_download_needed
    #
    # @param ignore_ttl [Boolean] If set to FALSE, PROJ will only check the recentness of an already downloaded file, if the delay between the last time it has been verified and the current time exceeds the TTL setting. This can save network accesses. If set to TRUE, PROJ will unconditionally check from the server the recentness of the file.
    #
    # @return [Boolean]
    def downloaded?(ignore_ttl = false)
      if self.context.network_enabled?
        result = Api.proj_is_download_needed(self.context, self.url&.to_s || self.name, ignore_ttl ? 1 : 0)
        result == 1 ? false : true
      else
        false
      end
    end

    # Download a file in the PROJ user-writable directory if has not already been downlaoded.
    # This function can only be used if networking is enabled
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_download_file
    #
    # @param ignore_ttl [Boolean] If set to FALSE, PROJ will only check the recentness of an already downloaded file, if the delay between the last time it has been verified and the current time exceeds the TTL setting. This can save network accesses. If set to TRUE, PROJ will unconditionally check from the server the recentness of the file.
    # @yieldparam percent [Double] The progress downloading the file in the range of 0 to 1
    #
    # @return [Boolean] True if the download was successful or unneeded. Otherwise false
    def download(ignore_ttl = false)
      callback = if block_given?
                   Proc.new do |context, percent, user_data|
                     result = yield percent
                     # Return 1 to tell Proj to keep downloading the file
                     result ? 1 : 0
                   end
                 end

      result = Api.proj_download_file(self.context, self.url&.to_s || self.name, ignore_ttl ? 1 : 0, callback, nil)
      result == 1 ? true : false
    end

    # Deletes the grid if it has been downloaded
    def delete
      if self.downloaded?
        path = File.join(self.context.user_directory, self.name)
        File.delete(path) if File.exist?(path)
      end
    end

    # Returns the path to the grid if it has been downloaded
    #
    # @return [String]
    def path
      if self.downloaded?
        File.join(self.context.user_directory, self.name)
      end
    end
  end
end
