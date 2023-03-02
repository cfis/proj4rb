module Proj
  # Manages remote access to grids and GeoTIFF grids. If network access is enabled,
  # then Proj can download grid files that are required for coordinate transformations
  # but are not installed on the local machine.e when
  class GridManager
    attr_reader :context

    # Create a new grid manager
    #
    # @param context [Context] A proj Context
    #
    # @return [GridManager]
    def initialize(context)
      @context = context
    end

    # Returns the cache used to store grid files locally
    #
    # @return [GridCache]
    def cache
      GridCache.new(self)
    end

    # Returns if network access is enabled allowing {Grid} files to be downloaded
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_is_network_enabled proj_context_is_network_enabled
    #
    # @return [Boolean] True if network access is enabled, otherwise false
    def network_enabled?
      result = Api.proj_context_is_network_enabled(self.context)
      result == 1 ? true : false
    end

    # Enable or disable network access for downloading grid files
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_enable_network proj_context_set_enable_network
    #
    # @param value [Boolean] Specifies if network access should be enabled or disabled
    def network_enabled=(value)
      Api.proj_context_set_enable_network(self.context, value ? 1 : 0)
    end

    # Returns the URL endpoint to query for remote grids
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_url_endpoint proj_context_get_url_endpoint
    #
    # @return [String] Endpoint URL
    def url
      Api.proj_context_get_url_endpoint(self.context)
    end

    # Sets the URL endpoint to query for remote grids. This overrides the default endpoint in the PROJ configuration file or with the PROJ_NETWORK_ENDPOINT environment variable.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_url_endpoint proj_context_set_url_endpoint
    #
    # @param value [String] Endpoint URL
    def url=(value)
      Api.proj_context_set_url_endpoint(self.context, value)
    end

    # Returns the user directory used to save grid files.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_user_writable_directory proj_context_get_user_writable_directory
    #
    # @param [Boolean] If set to TRUE, create the directory if it does not exist already. Defaults to false
    #
    # @return [String] Directory
    def user_directory(create = false)
      Api.proj_context_get_user_writable_directory(self.context, create ? 1 : 0)
    end

    # Returns if a grid is available in the PROJ user-writable directory.
    # This function can only be used if networking is enabled
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_is_download_needed proj_is_download_needed
    #
    # @param url [String] URL or filename without directory component
    # @param ignore_ttl [Boolean] If set to FALSE, PROJ will only check the recentness of an already downloaded file, if the delay between the last time it has been verified and the current time exceeds the TTL setting. This can save network accesses. If set to TRUE, PROJ will unconditionally check from the server the recentness of the file.
    #
    # @return [Boolean]
    def downloaded?(url, ignore_ttl = false)
      result = Api.proj_is_download_needed(self.context, url, ignore_ttl ? 1 : 0)
      result == 1 ? false : true
    end

    # Download a file in the PROJ user-writable directory if has not already been downlaoded.
    # This function can only be used if networking is enabled
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_download_file proj_download_file
    #
    # @param url [String] URL or filename without directory component
    # @param ignore_ttl [Boolean] If set to FALSE, PROJ will only check the recentness of an already downloaded file, if the delay between the last time it has been verified and the current time exceeds the TTL setting. This can save network accesses. If set to TRUE, PROJ will unconditionally check from the server the recentness of the file.
    # @yieldparam percent [Double] The progress downloading the file in the range of 0 to 1
    #
    # @return [Boolean] True if the download was successful or unneeded. Otherwise false
    def download(url, ignore_ttl = false)
      callback = if block_given?
                   Proc.new do |context, percent, user_data|
                     yield percent
                   end
                 end

      result = Api.proj_download_file(self.context, url, ignore_ttl ? 1 : 0, callback)
      result == 1 ? true : false
    end
  end
end
