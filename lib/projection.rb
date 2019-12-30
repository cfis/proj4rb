# encoding: UTF-8

module Proj
  # @deprecated This class is *DEPRECATED.* It will be removed when Proj 7 is released and removes the
  #   underlying API's this class uses. Code should be ported to use Crs and Transformation objects.
  class Projection
    def self.parse(value)
      values = case value
                 when Array
                   value
                 when String
                   value.strip.split(' ')
                 when Hash
                   array = []
                   value.each_pair do |key, value|
                     key = "+#{key}"
                     array << (value.nil? ? key : "#{key}=#{value}")
                   end
                   array
                 when Projection
                   value.getDef.split(' ')
                 else
                   raise ArgumentError, "Unknown type #{value.class} for projection definition"
               end
    end

    def self.finalize(pointer)
      proc do
        Api.pj_free(pointer)
      end
    end

    # Projection classes are created using Proj4 strings which consist of a number of parameters.
    # For more information please see the +opt arguments section at https://proj.org/apps/proj.html.
    #
    # @param value [string, array, hash] Parameters can be specified as strings, arrays or hashes.
    #
    # @example
    #   proj = Projection.new("+proj=utm +zone=21 +units=m")
    #   proj = Projection.new ["+proj=utm", "+zone=21", "+units=m"]
    #   proj = Projection.new("proj" => "utm", "zone" => "21", "units" => "m")
    #
    # With all variants the plus sign in front of the keys is optional.
    def initialize(value)
      params = self.class.parse(value)
      p_params = FFI::MemoryPointer.new(:pointer, params.length)
      params.each_with_index do |param, i|
        p_param = FFI::MemoryPointer.from_string(param)
        p_params[i].write_pointer(p_param)
      end

      @pointer = Api.pj_init(params.count, p_params)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)

      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    def to_ptr
      @pointer
    end

    # Returns projection definitions
    #
    # @return [String]
    def getDef
      Api.pj_get_def(self, 0)
    end

    # Returns if this is a geocentric projection
    #
    # @return [Boolean]
    def isGeocent?
      Api::pj_is_geocent(self)
    end
    alias :isGeocentric? :isGeocent?

    # Returns if this is a lat/long projection
    #
    # @return [Boolean]
    def isLatLong?
      Api::pj_is_latlong(self)
    end

    # Get the ID of this projection.
    #
    # @return [String]
    def projection
      getDef =~ /\+proj=(.+?) / ?  $1 : nil
    end

    # Get the ID of the datum used in this projection.
    #
    # @return [String]
    def datum
      getDef =~ /\+datum=(.+?) / ? $1 : nil
    end

    # Get definition of projection in typical inspect format (#<Proj::Projection +init=... +proj=... ...>).
    #
    # @return [String]
    def to_s
      "#<#{self.class.name}#{getDef}>"
    end

    # Forward projection of a point. Returns a copy of the point object with coordinates projected.
    #
    # @param point [Point] in radians
    # @return [Point] in cartesian coordinates
    def forward(point)
      struct = Api.pj_fwd3d(point, self)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)
      Point.from_pointer(struct)
    end

    # Convenience function for calculating a forward projection with degrees instead of radians.
    #
    # @param point [Point] in degrees
    # @return [Point] in cartesian coordinates
    def forwardDeg(point)
      forward(point.to_radians)
    end

    # Projects all points in a collection.
    #
    # @param collection [Enumerable<Point>] Points specified in radians
    # @return [Enumerable<Point>] Points specified in cartesian coordinates
    def forward_all(collection)
      collection.map do |point|
        forward(point)
      end
    end

    # Inverse projection of a point. Returns a copy of the point object with coordinates projected.
    #
    # @param point [Point] in cartesian coordinates
    # @return [Point] in radians
    def inverse(point)
      struct = Api.pj_inv3d(point, self)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)
      Point.from_pointer(struct)
    end

    # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
    #
    # @param point [Point] in cartesian coordinates
    # @return [Point] in degrees
    def inverseDeg(point)
      result = inverse(point)
      result.to_degrees
    end

    # Inverse projection of all points in a collection.
    #
    # @param collection [Enumerable<Point>] Points specified in cartesian coordinates
    # @return [Enumerable<Point>] Points specified in radians
    def inverse_all(collection)
      collection.map do |point|
        inverse(point)
      end
    end

    # Transforms a point from one projection to another.
    #
    # @param other [Projection]
    # @param point [Point]
    # @return [Point]
    def transform(other, point)
      p_x = FFI::MemoryPointer.new(:double, 1)
      p_x.write_double(point.x)

      p_y = FFI::MemoryPointer.new(:double, 1)
      p_y.write_double(point.y)

      p_z = FFI::MemoryPointer.new(:double, 1)
      p_z.write_double(point.z)

      a = Api.pj_transform(self, other, 1, 1, p_x, p_y, p_z)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)

      Point.new(p_x.read_double, p_y.read_double, p_z.read_double)
    end

    # Transforms all points in a collection from one projection to
    # another. The +collection+ object must implement the +each+,
    # +clear+, and << methods (just like an Array) for this to work.
    #
    # @param other [Projection]
    # @param collection [Enumerable, Point]
    # @return [Enumerable, Point]
    def transform_all(other, collection)
      collection.map do |point|
        transform(other, point)
      end
    end
  end
end