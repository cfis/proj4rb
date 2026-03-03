module Proj
  # Include this module in a class to create a custom file API for PROJ.
  # Install it via {Context#set_file_api}.
  #
  # The including class must call {#install_callbacks} in its initializer and
  # implement the following methods:
  #
  # * +open(path, access_mode)+ - Open a file. +access_mode+ is one of
  #   +:PROJ_OPEN_ACCESS_READ_ONLY+, +:PROJ_OPEN_ACCESS_READ_UPDATE+, or
  #   +:PROJ_OPEN_ACCESS_CREATE+. Return a file object (any Ruby object) or nil on error.
  # * +read(file, size_bytes)+ - Read up to +size_bytes+ from +file+, return a String.
  # * +write(file, data)+ - Write +data+ to +file+, return the number of bytes written.
  # * +seek(file, offset, whence)+ - Seek within +file+ using SEEK_SET/SEEK_CUR/SEEK_END.
  # * +tell(file)+ - Return the current position in +file+.
  # * +close(file)+ - Close +file+.
  # * +exists(path)+ - Return true if the file at +path+ exists.
  # * +mkdir(path)+ - Create directory at +path+, return true on success.
  # * +unlink(path)+ - Remove file at +path+, return true on success.
  # * +rename(original_path, new_path)+ - Rename a file, return true on success.
  #
  # The +file+ parameter passed to read/write/seek/tell/close is whatever object
  # your +open+ method returned.
  #
  # @example
  #   class MyFileApi
  #     include Proj::FileApiCallbacks
  #
  #     def initialize(context)
  #       install_callbacks(context)
  #     end
  #
  #     def open(path, access_mode)
  #       # return a file object or nil
  #     end
  #     # ... implement remaining methods ...
  #   end
  #
  #   context.set_file_api(MyFileApi)
  module FileApiCallbacks
    def install_callbacks(context)
      # PROJ keeps using this structure after proj_context_set_fileapi returns,
      # so it must be retained on the Ruby object to avoid GC invalidating it.
      @proj_file_api = Api::ProjFileApi.new
      @proj_file_api[:version] = 1

      # Maps native address -> {proj_handle:, file:}. Retaining proj_handle
      # prevents the MemoryPointer from being GCed while PROJ holds the address.
      @file_api_handles = {}

      @proj_file_api[:open_cbk] = self.method(:open_callback)
      @proj_file_api[:read_cbk] = self.method(:read_callback)
      @proj_file_api[:write_cbk] = self.method(:write_callback)
      @proj_file_api[:seek_cbk] = self.method(:seek_callback)
      @proj_file_api[:tell_cbk] = self.method(:tell_callback)
      @proj_file_api[:close_cbk] = self.method(:close_callback)
      @proj_file_api[:exists_cbk] = self.method(:exists_callback)
      @proj_file_api[:mkdir_cbk] = self.method(:mkdir_callback)
      @proj_file_api[:unlink_cbk] = self.method(:unlink_callback)
      @proj_file_api[:rename_cbk] = self.method(:rename_callback)

      result = Api.proj_context_set_fileapi(context, @proj_file_api, nil)

      if result != 1
        Error.check_object(self)
      end
    end

    # Open file. Return NULL if error
    def open_callback(context, path, access_mode, user_data)
      file = self.open(path, access_mode)
      return nil unless file
      register_handle(file)
    end

    # Read sizeBytes into buffer from current position and return number of bytes read
    def read_callback(context, handle, buffer, size_bytes, user_data)
      file = handle_to_file(handle)
      data = self.read(file, size_bytes)
      return 0 if data.nil? || data.empty?

      read_bytes = [size_bytes, data.bytesize].min
      buffer.put_bytes(0, data, 0, read_bytes)
      read_bytes
    end

    # Write sizeBytes into buffer from current position and return number of bytes written
    def write_callback(context, handle, buffer, size_bytes, user_data)
      file = handle_to_file(handle)
      data = buffer.get_bytes(0, size_bytes)
      self.write(file, data)
    end

    # Seek to offset using whence=SEEK_SET/SEEK_CUR/SEEK_END. Return TRUE in case of success
    def seek_callback(context, handle, offset, whence, user_data)
      file = handle_to_file(handle)
      self.seek(file, offset, whence)
      return 1 # True
    end

    # Return current file position
    def tell_callback(context, handle, user_data)
      file = handle_to_file(handle)
      self.tell(file)
    end

    # Close file
    def close_callback(context, handle, user_data)
      file = handle_to_file(handle)
      self.close(file)
      unregister_handle(handle)
    end

    # Return TRUE if a file exists
    def exists_callback(context, path, user_data)
      if self.exists(path)
        1
      else
        0
      end
    end

    # Return TRUE if directory exists or could be created
    def mkdir_callback(context, path, user_data)
      if self.mkdir(path)
        1
      else
        0
      end
    end

    # Return TRUE if file could be removed
    def unlink_callback(context, path, user_data)
      if self.unlink(path)
        1
      else
        0
      end
    end

    # Return TRUE if file could be renamed
    def rename_callback(context, original_path, new_path, user_data)
      if self.rename(original_path, new_path)
        1
      else
        0
      end
    end

    # Create an opaque handle for PROJ and associate it with a file object.
    # The MemoryPointer is retained to prevent GC while PROJ holds the address.
    def register_handle(file)
      proj_handle = FFI::MemoryPointer.new(:pointer)
      @file_api_handles[proj_handle.address] = { proj_handle: proj_handle, file: file }
      proj_handle
    end

    def handle_to_file(handle)
      @file_api_handles[handle.address][:file]
    end

    def unregister_handle(handle)
      @file_api_handles.delete(handle.address)
    end
  end
end
