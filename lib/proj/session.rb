module Proj
  class Session
    attr_reader :context

    def self.finalize(context, pointer)
      proc do
        Api.proj_insert_object_session_destroy(context, pointer)
      end
    end

    def initialize(context = nil)
      @context = context || Context.current
      @pointer = Api.proj_insert_object_session_create(@context)
      ObjectSpace.define_finalizer(self, self.class.finalize(@context, @pointer))
    end

    def to_ptr
      @pointer
    end

    # Returns SQL statements needed to insert the passed object into the database.
    #
    # @param object [PjObject] - The object to insert into the database. Currently only PrimeMeridian, Ellipsoid, Datum, GeodeticCRS, ProjectedCRS, VerticalCRS, CompoundCRS or BoundCRS are supported.
    # @param authority [String] - Authority name into which the object will be inserted. Must not be nil
    # @param code [Integer] - Code with which the object will be inserted.Must not be nil
    # @param numeric_codes [Boolean] - Whether intermediate objects that can be created should use numeric codes (true), or may be alphanumeric (false)
    # @param allowed_authorities  [Array[String]] - Authorities to which intermediate objects are allowed to refer to. "authority" will be implicitly added to it.
    #
    # @return [Strings] - List of insert statements
    def get_insert_statements(object, authority, code, numeric_codes = false, allowed_authorities = nil)
      allowed_authorities_ptr = if allowed_authorities
                                  # Add extra item at end for null pointer
                                  pointer = FFI::MemoryPointer.new(:pointer, allowed_authorities.size + 1)

                                  # Convert strings to C chars
                                  allowed_authorities.each_with_index do |authority, i|
                                    pointer.put_pointer(i, FFI::MemoryPointer.from_string(authority))
                                  end
                                  pointer
                                end

      strings_ptr = Api.proj_get_insert_statements(self.context, self, object, authority, code, numeric_codes ? 1 : 0, allowed_authorities_ptr, nil)
      Strings.new(strings_ptr)
    end
  end
end
