module Proj
  # Wraps a hash of key-value pairs as a null-terminated array of
  # "KEY=VALUE" C string pointers suitable for PROJ option parameters.
  #
  # Many PROJ C API functions accept an optional array of "KEY=VALUE" strings
  # to control their behavior. This class builds the required pointer array
  # and keeps the underlying FFI memory alive so that the garbage collector
  # cannot free it before the C call returns.
  #
  # @example
  #   options = Proj::Options.new("MULTILINE": "YES", "INDENTATION_WIDTH": 4)
  #   Api.proj_as_wkt(context, pj, :PJ_WKT2_2019, options)
  class Options
    # Creates a new Options instance.
    #
    # @param options [Hash{String, Symbol => String, Integer, nil}] Key-value pairs.
    #   Entries with nil values are removed.
    def initialize(options = {})
      options = options.compact
      @string_ptrs = options.map do |key, value|
        FFI::MemoryPointer.from_string("#{key}=#{value}")
      end

      if @string_ptrs.empty?
        @pointer = nil
      else
        @pointer = FFI::MemoryPointer.new(:pointer, options.size + 1)
        @pointer.write_array_of_pointer(@string_ptrs)
      end
    end

    # Returns the pointer to the null-terminated string array, or a
    # NULL pointer if no options were provided.
    #
    # @return [FFI::Pointer]
    def to_ptr
      @pointer || FFI::Pointer::NULL
    end
  end
end
