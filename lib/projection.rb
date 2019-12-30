# encoding: UTF-8

module Proj
  # The Projection class represents a geographical projection.
  #
  # = Creating a new projection object
  #
  # Projection objects are created through the new method as usual. Depending on the kind of projection, many
  # different parameters are needed. Please consult the documentation of the Proj.4 C library at http://trac.osgeo.org/proj/
  # for details.
  #
  # There are several ways of specifying the parameters:
  #
  # [<b>as a String:</b>] A string with the parameters in '[+]key=value' format concatenated together. This is the format used by the <tt>proj</tt> and <tt>cs2cs</tt> command line tool.
  #
  #      proj = Projection.new "+proj=utm +zone=21 +units=m"
  #
  # [<b>as an Array:</b>] An array with each parameter as a member in the array in '[+]key=value' format.
  #
  #      proj = Projection.new [ "proj=utm", "zone=21", "units=m" ]
  #
  # [<b>as a Hash:</b>] A hash with strings or symbols as keys.
  #
  #      proj = Projection.new( "proj" => "utm", "zone" => "21", "units" => "m" )
  #      proj = Projection.new( :proj => "utm", :zone => "21", :units => "m" )
  #
  # With all variants the plus sign in front of the keys is optional.
  #
  # = Using a projection object to project points
  #
  # There are two ways a projection can be used: Through the +forward+ and +inverse+ methods (with all their variants)
  # you can do projection from longitudes and latitudes into the coordinate system used by the projection and back.
  # These projections are always 2D, i.e. you need and get lon/lat or x/y coordinates.
  #
  # The alternative is the +transform+ method (with all its variants) which is used to transform 3D points from one
  # projection and datum to another. In addition to the x/y coordinates the transform method also reads and returns
  # a z coordinate.
  #
  # = Versions of the projection methods
  #
  # All three projection methods (+forward+, +inverse+, and +transform+) work on points. Every method has an in-place
  # version (with a name ending in !) which changes the given point and a normal version which first creates a copy of
  # the point object and changes and returns that. All methods use radians when reading or returning points. For
  # convenience there are also +forwardDeg+ and +inverseDeg+ methods (and in-place versions <tt>forwardDeg!</tt>
  # and <tt>inverseDeg!</tt>) that will work with degrees.
  #
  # = Points
  #
  # All projection method project points to other points. You can use objects of the Proj4::Point class for this or
  # any other object which supports the x, y, z read and write accessor methods. (In fact you don't even need the
  # z accessor methods, 0 is assumed if they don't exist.)
  #
  # Some projection methods act on the given point in-place, other return a copy of the point object. But in any case
  # all other attributes of the point object are retained.
  #
  # = Projection collections
  #
  # The methods forward_all, inverse_all, and transform_all (and their in-place versions forward_all!,
  # inverse_all!, and transform_all! work just like their simple counterparts, but instead of a single
  # point they convert a collection of points in one go.
  #
  # These methods all take an array as an argument or any object responding to the +each+ method (for the in-place versions)
  # or +each+, +clear+, and <tt><<</tt> methods (for the normal version).
  #
  # Some projection methods act on the given collection in-place, i.e. the collection is not touched and all points
  # in the collection will be projected in-place. The other methods act on a copy of the collection and on copies
  # of each point in the collection. So you'll get back a brand new copy of the collection with new copies of the
  # points with the projected coordinates. In any case all other attributes of the collection and points are retained.

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
                 when Proj4::Projection
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

    def initialize(value)
      params = self.class.parse(value)
      p_params = FFI::MemoryPointer.new(:pointer, params.length)
      params.each_with_index do |param, i|
        p_param = FFI::MemoryPointer.from_string(param)
        p_params[i].write_pointer(p_param)
      end

      @pointer = Proj4::Api.pj_init(params.count, p_params)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)

      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    def to_ptr
      @pointer
    end

    def getDef
      Api.pj_get_def(self, 0)
    end

    def isGeocent?
      Api::pj_is_geocent(self)
    end
    alias :isGeocentric? :isGeocent?

    def isLatLong?
      Api::pj_is_latlong(self)
    end

    # Get the ID of this projection.
    #
    # call-seq: projection -> String
    #
        def projection
          getDef =~ /\+proj=(.+?) / ?  $1 : nil
        end

    # Get the ID of the datum used in this projection.
    #
    # call-seq: datum -> String
    #
    def datum
      getDef =~ /\+datum=(.+?) / ? $1 : nil
    end

    # Get definition of projection in typical inspect format (#<Proj4::Projection +init=... +proj=... ...>).
    #
    # call-seq: to_s -> String
    #
    def to_s
      "#<Proj4::Projection#{ getDef }>"
    end

    # Forward projection of a point. Returns a copy of the point object with coordinates projected.
    #
    # call-seq: forward(point) -> point
    #
    def forward(point)
      struct = Api.pj_fwd3d(point, self)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)
      Point.from_pointer(struct)
    end

    # Convenience function for calculating a forward projection with degrees instead of radians.
    #
    # call-seq: forwardDeg(point) -> point
    #
    def forwardDeg(point)
      forward(point.to_radians)
    end

    # Projects all points in a collection.
    # The +collection+ object must implement the +each+,
    # +clear+, and << methods (just like an Array) for this to work.
    #
    # call-seq: forward_all(collection) -> collection
    #
    def forward_all(collection)
      collection.map do |point|
        forward(point)
      end
    end

    # Inverse projection of a point. Returns a copy of the point object with coordinates projected.
    #
    # call-seq: inverse(point) -> point
    #
    def inverse(point)
      struct = Api.pj_inv3d(point, self)
      ptr = Api.pj_get_errno_ref
      Error.check(ptr.read_int)
      Point.from_pointer(struct)
    end

    # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
    #
    # call-seq: inverseDeg(point) -> point
    #
    def inverseDeg(point)
      result = inverse(point)
      result.to_degrees
    end

    # Projects all points in a collection.
    # The +collection+ object must implement the +each+,
    # +clear+, and << methods (just like an Array) for this to work.
    #
    # call-seq: inverse_all(collection) -> collection
    #
    def inverse_all(collection)
      collection.map do |point|
        inverse(point)
      end
    end

    # Transforms a point from one projection to another.
    #
    # call-seq: transform(destinationProjection, point) -> point
    #
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
    # call-seq: transform_all(destinationProjection, collection) -> collection
    #
    def transform_all(other, collection)
      collection.map do |point|
        transform(other, point)
      end
    end
  end
end
