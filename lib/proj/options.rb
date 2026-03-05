module Proj
  # Wraps a hash of key-value pairs as a null-terminated array of
  # "KEY=VALUE" C string pointers suitable for PROJ option parameters.
  # Prevents GC from collecting the individual string pointers before
  # the C call that reads them has returned.
  class Options
    def initialize(options)
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

    def to_ptr
      @pointer || FFI::Pointer::NULL
    end
  end
end
