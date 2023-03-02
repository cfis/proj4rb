module Proj
  # Proj has the ability to downlaod {Grid Grids} on the fly using libcurl.
  #
  # The GridDownloader class enables advanced users to replace libcurl with their
  # own network implementation. This may be necessary if Proj was built without libcurl or
  # special code is required to handle SSL, proxy, authentication, etc. issues.
  #
  # Users should create a subclass of GridDownloader and reimplement its methods as needed
  class GridDownloader
    attr_reader :context

    module Callbacks
      def self.open(downloader, context, path, access_mode, user_data)
        result = downloader.open(path, access_mode)
        result ?  FFI::MemoryPointer.new(:size_t) : nil
      end

      def self.read(downloader, context, handle, buffer, size_bytes, user_data)
        bytes = downloader.read(size_bytes)
        buffer.put_bytes(0, bytes, 0, bytes.size)
        bytes.size
      end

      def self.write(downloader, context, handle, buffer, size_bytes, user_data)
        data = buffer.get_bytes(0, size_bytes)
        downloader.write(data)
      end

      def self.seek(downloader, context, handle, offset, whence, user_data)
        downloader.seek(offset, whence)
        return 1 # True
      end

      def self.tell(downloader, context, handle, user_data)
        downloader.tell
      end

      def self.close(downloader, context, handle, user_data)
        downloader.close
      end

      def self.exists(context, path, user_data)
        result = File.exist?(path)
        result ? 1 : 0
      end

      def self.mkdir(context, path, user_data)
        Dir.mkdir(path)
      end

      def self.unlink(context, path, user_data)
        File.unlink(path) if File.exist?(path)
        return 1 # True
      end

      def self.rename(context, original_path, new_path, user_data)
        File.rename(original_path, new_path)
        return 1 # True
      end
    end

    def initialize(context)
      @context = context
      
      # Curry callback so we can pass self to them, and also keep references
      # to them so they don't get garbage collected
      @open_cbk = Callbacks.method(:open).curry[self]
      @read_cbk = Callbacks.method(:read).curry[self]
      @write_cbk = Callbacks.method(:write).curry[self]
      @seek_cbk = Callbacks.method(:seek).curry[self]
      @tell_cbk = Callbacks.method(:tell).curry[self]
      @close_cbk = Callbacks.method(:close).curry[self]
      @exists_cbk = Callbacks.method(:exists)
      @mkdir_cbk = Callbacks.method(:mkdir)
      @unlink_cbk = Callbacks.method(:unlink)
      @rename_cbk = Callbacks.method(:rename)

      proj_file_api = Api::PROJ_FILE_API.new
      proj_file_api[:version] = 1
      proj_file_api[:open_cbk] = @open_cbk
      proj_file_api[:read_cbk] = @read_cbk
      proj_file_api[:write_cbk] = @write_cbk
      proj_file_api[:seek_cbk] = @seek_cbk
      proj_file_api[:tell_cbk] = @tell_cbk
      proj_file_api[:close_cbk] = @close_cbk
      proj_file_api[:exists_cbk] = @exists_cbk
      proj_file_api[:mkdir_cbk] = @mkdir_cbk
      proj_file_api[:unlink_cbk] = @unlink_cbk
      proj_file_api[:rename_cbk] = @rename_cbk

      result = Api.proj_context_set_fileapi(self.context, proj_file_api, nil)

      if result != 1
        Error.check(self.context)
      end

      true
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

    def read(buffer, size_bytes)
      @file.read(size_bytes)
    end

    def write(data)
      @file.write(data)
    end

    def seek(downloader, context, handle, offset, whence, user_data)
      @file.seek(offset, whence)
    end

    def tell
      @file.tell
    end

    def close
      @file.close
    end
  end
end