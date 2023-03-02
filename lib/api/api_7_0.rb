module Proj
  module Api
    # ---- File API ----------
    typedef :pointer, :PROJ_FILE_HANDLE
    typedef :pointer, :USER_DATA

    PROJ_OPEN_ACCESS = enum(:PROJ_OPEN_ACCESS_READ_ONLY, # Read-only access. Equivalent to "rb"
                            :PROJ_OPEN_ACCESS_READ_UPDATE, # Read-update access. File should be created if not existing. Equivalent to "r+b
                            :PROJ_OPEN_ACCESS_CREATE) # Create access. File should be truncated to 0-byte if already existing. Equivalent to "w+b"

    # File API callbacks
    # Open file. Return NULL if error
    callback :open_cbk, [:PJ_CONTEXT, :string, PROJ_OPEN_ACCESS, :USER_DATA], :PROJ_FILE_HANDLE

    # Read sizeBytes into buffer from current position and return number of bytes read
    callback :read_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :pointer, :size_t, :USER_DATA], :size_t

    # Write sizeBytes into buffer from current position and return number of bytes written
    callback :write_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :pointer, :size_t, :USER_DATA], :size_t

    # Seek to offset using whence=SEEK_SET/SEEK_CUR/SEEK_END. Return TRUE in case of success
    callback :seek_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :long_long, :int, :USER_DATA], :int

    # Return current file position
    callback :tell_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :USER_DATA], :long_long

    # Close file
    callback :close_cbk, [:PJ_CONTEXT, :PROJ_FILE_HANDLE, :USER_DATA], :void

    # Return TRUE if a file exists
    callback :exists_cbk, [:PJ_CONTEXT, :string, :USER_DATA], :int

    # Return TRUE if directory exists or could be created
    callback :mkdir_cbk, [:PJ_CONTEXT, :string, :USER_DATA], :int

    # Return TRUE if file could be removed
    callback :unlink_cbk, [:PJ_CONTEXT, :string, :USER_DATA], :int

    # Return TRUE if file could be renamed
    callback :rename_cbk, [:PJ_CONTEXT, :string, :string, :USER_DATA], :int

    # Progress callback. The passed percentage is in the range [0, 1]. The progress callback must return
    # TRUE if the download should be continued.
    callback :progress_cbk, [:PJ_CONTEXT, :double, :USER_DATA], :int

    class PROJ_FILE_API < FFI::Struct
      layout :version,    :int,     # Version of this structure. Should be set to 1 currently.
             :open_cbk,   :open_cbk,
             :read_cbk,   :read_cbk,
             :write_cbk,  :write_cbk,
             :seek_cbk,   :seek_cbk,
             :tell_cbk,   :tell_cbk,
             :close_cbk,  :close_cbk,
             :exists_cbk, :exists_cbk,
             :mkdir_cbk,  :mkdir_cbk,
             :unlink_cbk, :unlink_cbk,
             :rename_cbk, :rename_cbk
    end

    attach_function :proj_context_set_fileapi, [:PJ_CONTEXT, PROJ_FILE_API, :USER_DATA], :int

    attach_function :proj_is_download_needed, [:PJ_CONTEXT, :string, :int], :int
    attach_function :proj_download_file, [:PJ_CONTEXT, :string, :int, :progress_cbk, :USER_DATA], :int

    # --------- Network API ------------
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
  end
end