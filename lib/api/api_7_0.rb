module Proj
  module Api
    # ---- File API ----------
    typedef :pointer, :PROJ_FILE_HANDLE
    typedef :pointer, :USER_DATA

    PROJ_OPEN_ACCESS = enum(:PROJ_OPEN_ACCESS_READ_ONLY, # Read-only access. Equivalent to "rb"
                            :PROJ_OPEN_ACCESS_READ_UPDATE, # Read-update access. File should be created if not existing. Equivalent to "r+b
                            :PROJ_OPEN_ACCESS_CREATE) # Create access. File should be truncated to 0-byte if already existing. Equivalent to "w+b"

    # File API callbacks
    callback :open_file_cbk, [:PJ_CONTEXT, :string, PROJ_OPEN_ACCESS, :USER_DATA], :PROJ_FILE_HANDLE
    callback :read_file_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :pointer, :size_t, :USER_DATA], :size_t
    callback :write_file_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :pointer, :size_t, :USER_DATA], :size_t
    callback :seek_file_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :long_long, :int, :USER_DATA], :int
    callback :tell_file_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :USER_DATA], :long_long
    callback :close_file_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :USER_DATA], :void
    callback :exists_file_cbk, [:PJ_CONTEXT, :string, :USER_DATA], :int
    callback :mkdir_file_cbk, [:PJ_CONTEXT, :string, :USER_DATA], :int
    callback :unlink_file_cbk, [:PJ_CONTEXT, :string, :USER_DATA], :int
    callback :rename_file_cbk, [:PJ_CONTEXT, :string, :string, :USER_DATA], :int

    # Progress callback. The passed percentage is in the range [0, 1]. The progress callback must return
    # TRUE if the download should be continued.
    callback :progress_file_cbk, [:PJ_CONTEXT, :double, :USER_DATA], :int

    class PROJ_FILE_API < FFI::Struct
      layout :version,    :int, # Version of this structure. Should be set to 1 currently.
             :open_cbk,   :open_file_cbk,
             :read_cbk,   :read_file_cbk,
             :write_cbk,  :write_file_cbk,
             :seek_cbk,   :seek_file_cbk,
             :tell_cbk,   :tell_file_cbk,
             :close_cbk,  :close_file_cbk,
             :exists_cbk, :exists_file_cbk,
             :mkdir_cbk,  :mkdir_file_cbk,
             :unlink_cbk, :unlink_file_cbk,
             :rename_cbk, :rename_file_cbk
    end
    attach_function :proj_context_set_fileapi, [:PJ_CONTEXT, PROJ_FILE_API, :USER_DATA], :int
    attach_function :proj_is_download_needed, [:PJ_CONTEXT, :string, :int], :int
    attach_function :proj_download_file, [:PJ_CONTEXT, :string, :int, :progress_file_cbk, :USER_DATA], :int

    # --------- Network API ------------
    typedef :pointer, :PROJ_NETWORK_HANDLE
    callback :open_network_cbk, [:PJ_CONTEXT, :string, :ulong_long, :size_t, :pointer, :pointer, :size_t, :string, :USER_DATA], :PROJ_NETWORK_HANDLE
    callback :close_network_cbk, [:PJ_CONTEXT, :PROJ_NETWORK_HANDLE, :USER_DATA], :void
    callback :header_value_cbk, [:PJ_CONTEXT, :PROJ_NETWORK_HANDLE, :pointer, :USER_DATA], :pointer
    callback :read_range_cbk, [:PJ_CONTEXT, :PROJ_NETWORK_HANDLE, :ulong_long, :size_t, :pointer, :size_t, :string, :USER_DATA], :size_t
    attach_function :proj_context_set_network_callbacks, [:PJ_CONTEXT, :open_network_cbk, :close_network_cbk, :header_value_cbk, :read_range_cbk], :int

    attach_function :proj_context_is_network_enabled, [:PJ_CONTEXT], :int
    attach_function :proj_context_set_enable_network, [:PJ_CONTEXT, :int], :int
    attach_function :proj_is_download_needed, [:PJ_CONTEXT, :string, :int], :int
    attach_function :proj_context_set_url_endpoint, [:PJ_CONTEXT, :string], :void

    # --------- Cache ------------
    attach_function :proj_grid_cache_set_enable, [:PJ_CONTEXT, :int], :void
    attach_function :proj_grid_cache_set_filename, [:PJ_CONTEXT, :string], :void
    attach_function :proj_grid_cache_set_max_size, [:PJ_CONTEXT, :int], :void
    attach_function :proj_grid_cache_set_ttl, [:PJ_CONTEXT, :int], :void
    attach_function :proj_grid_cache_clear, [:PJ_CONTEXT], :void

    # -------- Other ----------
    attach_function :proj_assign_context, [:PJ, :PJ_CONTEXT], :void
  end
end