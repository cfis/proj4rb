require 'net/http'

module Proj
  module NetworkApiCallbacks
    def install_callbacks(context)
      @open_cbk = self.method(:open_callback)
      @close_cbk = self.method(:close_callback)
      @header_value_cbk = self.method(:header_value_callback)
      @read_range_cbk = self.method(:read_range_callback)

      result = Api.proj_context_set_network_callbacks(context, @open_cbk, @close_cbk, @header_value_cbk, @read_range_cbk, nil)

      if result != 1
        Error.check(self.context)
      end
    end

    def open_callback(context, url, offset, size_to_read, buffer, out_size_read, error_string_max_size, out_error_string, user_data)
      uri = URI.parse(url)
      data = self.open(uri, offset, size_to_read)
      out_size = [size_to_read, data.size].min
      out_size_read.write(:size_t, out_size)
      buffer.write_bytes(data, 0, out_size)

      # Return fake handle
      FFI::MemoryPointer.new(:size_t)
    end

    def close_callback(context, handle, user_data)
      self.close
    end

    def header_value_callback(context, handle, header_name_ptr, user_data)
      header_name = header_name_ptr.read_string_to_null
      value = self.header_value(header_name)
      FFI::MemoryPointer.from_string(value)
    end

    def read_range_callback(context, handle, offset, size_to_read, buffer, error_string_max_size, out_error_string, user_data)
      data = self.read_range(offset, size_to_read)
      out_size = [size_to_read, data.size].min
      buffer.write_bytes(data, 0, out_size)
      out_size
    end
  end

  # Proj allows its network api to be replaced by a custom implementation. This can be
  # done by calling Context#set_network_api with a user defined Class that includes the
  # NetworkApiCallbacks module and implements its required methods.
  #
  # @see https://proj.org/usage/network.html Network capabilities
  #
  # The NetworkApiImpl class is a simple example of a network api implementation.
  class NetworkApiImpl
    include NetworkApiCallbacks

    def initialize(context)
      install_callbacks(context)
    end

    def open(uri, offset, size_to_read)
      @uri = uri
      @http = Net::HTTP.new(@uri.host, @uri.port)
      if uri.scheme == "https"
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
      @http.start

      read_data(offset, size_to_read)
    end

    def close
      @http.finish
    end

    def header_value(name)
      @response[name]
    end

    def read_range(offset, size_to_read)
      read_data(offset, size_to_read)
    end

    def read_data(offset, size_to_read)
      headers = {"Range": "bytes=#{offset}-#{offset + size_to_read - 1}"}
      request = Net::HTTP::Get.new(@uri.request_uri, headers)
      @response = @http.request(request)
      @response.body.force_encoding("ASCII-8BIT")
    end
  end
end