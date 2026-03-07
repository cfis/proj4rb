  # encoding: UTF-8

module Proj
  # Represents a usage domain of a PjObject. Each domain has a scope
  # describing the purpose and a geographic area of use.
  # Objects can have multiple domains.
  class Domain
    # @return [String] The scope of this domain
    attr_reader :scope

    # @return [Area] The geographic area of use for this domain
    attr_reader :area_of_use

    # @param scope [String] The scope describing the purpose of this domain
    # @param area_of_use [Area] The geographic area of use
    def initialize(scope:, area_of_use:)
      @scope = scope
      @area_of_use = area_of_use
    end

    # Returns the number of usage domains for an object.
    # Requires PROJ 9.2+. Returns 1 on older versions for backward compatibility.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_domain_count
    #
    # @param pj_object [PjObject] The object to query
    #
    # @return [Integer]
    def self.count(pj_object)
      if Api.method_defined?(:proj_get_domain_count)
        Api.proj_get_domain_count(pj_object)
      else
        1
      end
    end

    # Returns all usage domains for an object.
    # On PROJ < 9.2, falls back to {Api.proj_get_scope} and {Api.proj_get_area_of_use}
    # and returns a single domain.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_scope_ex
    # @see https://proj.org/development/reference/functions.html#c.proj_get_area_of_use_ex
    #
    # @param pj_object [PjObject] The object to query
    #
    # @return [Array<Domain>]
    def self.domains(pj_object)
      use_ex = Api.method_defined?(:proj_get_domain_count)
      domain_count = use_ex ? Api.proj_get_domain_count(pj_object) : 1

      domain_count.times.map do |index|
        scope = use_ex ? Api.proj_get_scope_ex(pj_object, index) : Api.proj_get_scope(pj_object)

        p_name = FFI::MemoryPointer.new(:pointer)
        p_west = FFI::MemoryPointer.new(:double)
        p_south = FFI::MemoryPointer.new(:double)
        p_east = FFI::MemoryPointer.new(:double)
        p_north = FFI::MemoryPointer.new(:double)

        if use_ex
          result = Api.proj_get_area_of_use_ex(pj_object.context, pj_object, index,
                                                p_west, p_south, p_east, p_north, p_name)
        else
          result = Api.proj_get_area_of_use(pj_object.context, pj_object,
                                             p_west, p_south, p_east, p_north, p_name)
        end
        unless result
          Error.check_object(pj_object)
        end

        name = p_name.read_pointer.read_string_to_null.force_encoding('utf-8')
        area = Area.new(west_lon_degree: p_west.read_double,
                        south_lat_degree: p_south.read_double,
                        east_lon_degree: p_east.read_double,
                        north_lat_degree: p_north.read_double,
                        name: name)

        new(scope: scope, area_of_use: area)
      end
    end
  end
end
