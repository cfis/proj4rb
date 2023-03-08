module Proj
  module FileApiCallbacks
    def install_callbacks(context)
      proj_file_api = Api::PROJ_FILE_API.new
      proj_file_api[:version] = 1

      # Store procs to instance variables so they don't get garbage collected
      @open_cbk = proj_file_api[:open_cbk] = self.method(:open_callback)
      @read_cbk = proj_file_api[:read_cbk] = self.method(:read_callback)
      @write_cbk = proj_file_api[:write_cbk] = self.method(:write_callback)
      @seek_cbk = proj_file_api[:seek_cbk] = self.method(:seek_callback)
      @tell_cbk = proj_file_api[:tell_cbk] = self.method(:tell_callback)
      @close_cbk = proj_file_api[:close_cbk] = self.method(:close_callback)
      @exists_cbk = proj_file_api[:exists_cbk] = self.method(:exists_callback)
      @mkdir_cbk = proj_file_api[:mkdir_cbk] = self.method(:mkdir_callback)
      @unlink_cbk = proj_file_api[:unlink_cbk] = self.method(:unlink_callback)
      @rename_cbk = proj_file_api[:rename_cbk] = self.method(:rename_callback)

      result = Api.proj_context_set_fileapi(context, proj_file_api, nil)

      if result != 1
        Error.check(self.context)
      end
    end

    # Open file. Return NULL if error
    def open_callback(context, path, access_mode, user_data)
      result = self.open(path, access_mode)
      result ?  FFI::MemoryPointer.new(:size_t) : nil
    end

    # Read sizeBytes into buffer from current position and return number of bytes read
    def read_callback(context, handle, buffer, size_bytes, user_data)
      data = self.read(size_bytes)
      read_bytes = [size_bytes, data.size].min
      buffer.write_bytes(data, 0, read_bytes)
      read_bytes
    end

    # Write sizeBytes into buffer from current position and return number of bytes written
    def write_callback(context, handle, buffer, size_bytes, user_data)
      data = buffer.get_bytes(0, size_bytes)
      self.write(data)
    end

    # Seek to offset using whence=SEEK_SET/SEEK_CUR/SEEK_END. Return TRUE in case of success
    def seek_callback(context, handle, offset, whence, user_data)
      self.seek(offset, whence)
      return 1 # True
    end

    # Return current file position
    def tell_callback(context, handle, user_data)
      self.tell
    end

    # Close file
    def close_callback(context, handle, user_data)
      self.close
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
      if self.mdkir(path)
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
  end

  # Proj allows its file api to be replaced by a custom implementation. This can be
  # done by calling Context#set_file_api with a user defined Class that includes the
  # FileApiCallbacks module and implements its required methods.
  #
  # The FileApiImpl class is a simple example file api implementation.
  class FileApiImpl
    include FileApiCallbacks

    def initialize(context)
      install_callbacks(context)
    end

    def open(path, access_mode)
      case access_mode
      when :PROJ_OPEN_ACCESS_READ_ONLY
        if File.exist?(path)
          @file = File.open(path, :mode => 'rb')
        else
          nil # False
        end
      when :PROJ_OPEN_ACCESS_READ_UPDATE
        if File.exist?(path)
          @file = File.open(path, :mode => 'r+b')
        else
          nil # False
        end
      when :PROJ_OPEN_ACCESS_CREATE
        @file = File.open(path, :mode => 'wb')
      end
    end

    def read(size_bytes)
      @file.read(size_bytes)
    end

    def write(data)
      @file.write(data)
    end

    def seek(offset, whence)
      @file.seek(offset, whence)
    end

    def tell
      @file.tell
    end

    def close
      @file.close
    end

    def exists(path)
      File.exist?(path)
    end

    def mkdir(path)
      Dir.mkdir(path)
    end

    def unlink(path)
      File.unlink(path) if File.exist?(path)
    end

    def rename(original_path, new_path)
      File.rename(original_path, new_path)
    end
  end
end