module Proj
  # The FileApiExample class is a simple file api implementation that delegates
  # to Ruby's built-in File operations.
  class FileApiExample
    include FileApiCallbacks

    def initialize(context)
      install_callbacks(context)
    end

    def open(path, access_mode)
      case access_mode
      when :PROJ_OPEN_ACCESS_READ_ONLY
        File.open(path, mode: 'rb') if File.exist?(path)
      when :PROJ_OPEN_ACCESS_READ_UPDATE
        File.exist?(path) ? File.open(path, mode: 'r+b') : File.open(path, mode: 'w+b')
      when :PROJ_OPEN_ACCESS_CREATE
        File.open(path, mode: 'w+b')
      end
    end

    def read(file, size_bytes)
      file.read(size_bytes)
    end

    def write(file, data)
      file.write(data)
    end

    def seek(file, offset, whence)
      file.seek(offset, whence)
    end

    def tell(file)
      file.tell
    end

    def close(file)
      file.close
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
