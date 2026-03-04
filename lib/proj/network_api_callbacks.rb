module Proj
  # Include this module in a class to create a custom network API for PROJ.
  # Install it via {Context#set_network_api}.
  #
  # The including class must call {#install_callbacks} in its initializer and
  # implement the following methods:
  #
  # * +open(uri, offset, size_to_read)+ - Open a network connection and perform
  #   the initial read. Return a connection object (any Ruby object) that holds
  #   the connection state, along with the data read. The return value must be a
  #   Hash with at least a +:data+ key containing the bytes read.
  # * +close(connection)+ - Close the network connection.
  # * +header_value(connection, header_name)+ - Return the value of a response header.
  # * +read_range(connection, offset, size_to_read)+ - Read a range of bytes, return a String.
  #
  # The +connection+ parameter passed to close/header_value/read_range is whatever
  # object your +open+ method returned.
  module NetworkApiCallbacks
    def install_callbacks(context)
      @open_cbk = self.method(:open_callback)
      @close_cbk = self.method(:close_callback)
      @header_value_cbk = self.method(:header_value_callback)
      @read_range_cbk = self.method(:read_range_callback)

      # Maps native address -> {proj_handle:, connection:, header_ptrs: []}
      # Retaining proj_handle prevents the MemoryPointer from being GCed
      # while PROJ holds the address. header_ptrs retains string pointers
      # returned by header_value_callback.
      @network_handles = {}

      result = Api.proj_context_set_network_callbacks(context, @open_cbk, @close_cbk, @header_value_cbk, @read_range_cbk, nil)

      if result != 1
        Error.check_object(self)
      end
    end

    def open_callback(context, url, offset, size_to_read, buffer, out_size_read, error_string_max_size, out_error_string, user_data)
      uri = URI.parse(url)
      connection = self.open(uri, offset, size_to_read)
      out_size = [size_to_read, connection[:data].size].min
      out_size_read.write(:size_t, out_size)
      buffer.write_bytes(connection[:data], 0, out_size)

      register_handle(connection)
    end

    def close_callback(context, handle, user_data)
      connection = handle_to_connection(handle)
      self.close(connection)
      unregister_handle(handle)
    end

    def header_value_callback(context, handle, header_name, user_data)
      connection = handle_to_connection(handle)
      value = self.header_value(connection, header_name)
      ptr = FFI::MemoryPointer.from_string(value)
      @network_handles[handle.address][:header_ptrs] << ptr
      ptr
    end

    def read_range_callback(context, handle, offset, size_to_read, buffer, error_string_max_size, out_error_string, user_data)
      connection = handle_to_connection(handle)
      data = self.read_range(connection, offset, size_to_read)
      out_size = [size_to_read, data.size].min
      buffer.write_bytes(data, 0, out_size)
      out_size
    end

    private

    def register_handle(connection)
      proj_handle = FFI::MemoryPointer.new(:pointer)
      @network_handles[proj_handle.address] = { proj_handle: proj_handle, connection: connection, header_ptrs: [] }
      proj_handle
    end

    def handle_to_connection(handle)
      @network_handles[handle.address][:connection]
    end

    def unregister_handle(handle)
      @network_handles.delete(handle.address)
    end
  end
end
