# encoding: UTF-8

if File.exists?(File.dirname(__FILE__ + '/../data'))
 ENV['PROJ_LIB'] = File.dirname(__FILE__) + '/../data'
end

# Load the C-based binding.
begin
  RUBY_VERSION =~ /(\d+.\d+)/
  require "#{$1}/proj4_ruby"
rescue LoadError
  require "proj4_ruby"
end

# Ruby bindings for the Proj.4 cartographic projection library (http://trac.osgeo.org/proj/).
module Proj4

  # Base class for all Proj.4 exceptions. Subclasses with the name <errorname>Error are available for each exception.
  class Error < StandardError

    # List of all Proj.4 errors.
    #--
    # (This list is created from the one in pj_strerrno.c in the Proj.4 distribution.)
    #++
    ERRORS = %w{Unknown NoArgsInInitList NoOptionsInInitFile NoColonInInitString ProjectionNotNamed UnknownProjectionId EffectiveEccentricityEq1 UnknownUnitConversionId InvalidBooleanParamArgument UnknownEllipticalParameterName ReciprocalFlatteningIsZero RadiusReferenceLatitudeGt90 SquaredEccentricityLessThanZero MajorAxisOrRadiusIsZeroOrNotGiven LatitudeOrLongitudeExceededLimits InvalidXOrY ImproperlyFormedDMSValue NonConvergentInverseMeridinalDist NonConvergentInversePhi2 AcosOrAsinArgTooBig ToleranceCondition ConicLat1EqMinusLat2 Lat1GreaterThan90 Lat1IsZero LatTsGreater90 NoDistanceBetweenControlPoints ProjectionNotSelectedToBeRotated WSmallerZeroOrMSmallerZero LsatNotInRange PathNotInRange HSmallerZero KSmallerZero Lat0IsZeroOr90OrAlphaIsZero Lat1EqLat2OrLat1IsZeroOrLat2Is90 EllipticalUsageRequired InvalidUTMZoneNumber ArgsOutOfRangeForTchebyEval NoProjectionToBeRotated FailedToLoadNAD2783CorrectionFile BothNAndMMustBeSpecdAndGreaterZero NSmallerZeroOrNGreaterOneOrNotSpecified Lat1OrLat2NotSpecified AbsoluteLat1EqLat2 Lat0IsHalfPiFromMeanLat UnparseableCoordinateSystemDefinition GeocentricTransformationMissingZOrEllps UnknownPrimeMeridianConversionId}

    # Return list of all errors.
    #
    # call-seq: list -> Array
    #
    def self.list
      ERRORS
    end

    # Return name of error with given number.
    #
    # call-seq: error(errnum) -> String
    #
    def self.error(errnum)
      ERRORS[errnum.abs] || 'Unknown'
    end

    # Raise an error with error number +errnum+.
    def self.raise_error(errnum)
      raise eval("#{error(errnum.abs)}Error"), message(-(errnum.abs)), caller[0..-1]
    end

    # Return error number of this error.
    def errnum
      self.class.errnum
    end

  end

  Error.list.each_with_index do |err, index|
    eval "class #{err}Error < Error;
         def self.errnum;
           #{index};
         end;
        end"
  end

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
  #
  class Projection

    private

    def self._parse_init_parameters(args)
      case args
        when Array
          args.collect{ |a| a.sub(/^\+/, '') }
        when String
          args.strip.split(' ').collect{ |a| a.sub(/^\+/, '')}
        when Hash
          array = []
          args.each_pair{ | key, value | array << (value.nil? ? key.to_s : "#{key}=#{value}") }
          array
        when Proj4::Projection
          args.getDef.strip.split(' ').collect{ |a| a.sub(/^\+/, '')}
        else
          raise ArgumentError, "Unknown type #{args.class} for projection definition"
      end
    end

    public

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
      forward!(point.dup)
    end

    # Convenience function for calculating a forward projection with degrees instead of radians.
    #
    # call-seq: forwardDeg(point) -> point
    #
    def forwardDeg(point)
      forwardDeg!(point.dup)
    end

    # Convenience function for calculating a forward projection with degrees instead of radians.
    # This version works in-place, i.e. the point objects content is overwritten.
    #
    # call-seq: forwardDeg!(point) -> point
    #
    def forwardDeg!(point)
      point.x *= Proj4::DEG_TO_RAD
      point.y *= Proj4::DEG_TO_RAD
      forward!(point)
    end

    # Project all points in a collection 'in place'.
    # The +collection+ object must implement the +each+
    # method for this to work.
    #
    # call-seq: forward_all!(collection) -> collection
    #
    def forward_all!(collection)
      collection.each do |point|
        forward!(point)
      end
      collection
    end

    # Projects all points in a collection.
    # The +collection+ object must implement the +each+,
    # +clear+, and << methods (just like an Array) for this to work.
    #
    # call-seq: forward_all(collection) -> collection
    #
    def forward_all(collection)
      newcollection = collection.dup.clear
      collection.each do |point|
        newcollection << forward(point)
      end
      newcollection
    end

    # Inverse projection of a point. Returns a copy of the point object with coordinates projected.
    #
    # call-seq: inverse(point) -> point
    #
    def inverse(point)
      inverse!(point.dup)
    end

    # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
    #
    # call-seq: inverseDeg(point) -> point
    #
    def inverseDeg(point)
      inverseDeg!(point.dup)
    end

    # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
    # This version works in-place, i.e. the point objects content is overwritten.
    #
    # call-seq: inverseDeg!(point) -> point
    #
    def inverseDeg!(point)
      inverse!(point)
      point.x *= Proj4::RAD_TO_DEG
      point.y *= Proj4::RAD_TO_DEG
      point
    end

    # Project all points in a collection 'in place'.
    # The +collection+ object must implement the +each+
    # method for this to work.
    #
    # call-seq: inverse_all!(collection) -> collection
    #
    def inverse_all!(collection)
      collection.each do |point|
        inverse!(point)
      end
      collection
    end

    # Projects all points in a collection.
    # The +collection+ object must implement the +each+,
    # +clear+, and << methods (just like an Array) for this to work.
    #
    # call-seq: inverse_all(collection) -> collection
    #
    def inverse_all(collection)
      newcollection = collection.dup.clear
      collection.each do |point|
        newcollection << inverse(point)
      end
      newcollection
    end

    # Transforms a point from one projection to another.
    #
    # call-seq: transform(destinationProjection, point) -> point
    #
    def transform(otherProjection, point)
      transform!(otherProjection, point.dup)
    end

    # Transforms all points in a collection 'in place' from one projection
    # to another. The +collection+ object must implement the +each+
    # method for this to work.
    #
    # call-seq: transform_all!(destinationProjection, collection) -> collection
    #
    def transform_all!(otherProjection, collection)
      collection.each do |point|
        transform!(otherProjection, point)
      end
      collection
    end

    # Transforms all points in a collection from one projection to
    # another. The +collection+ object must implement the +each+,
    # +clear+, and << methods (just like an Array) for this to work.
    #
    # call-seq: transform_all(destinationProjection, collection) -> collection
    #
    def transform_all(otherProjection, collection)
      newcollection = collection.dup.clear
      collection.each do |point|
        newcollection << transform(otherProjection, point)
      end
      newcollection
    end

  end

  # This class represents a point in either lon/lat or projected x/y coordinates.
  class Point

    # X coordinate or longitude
    attr_accessor :x

    # Y coordinate or latitude
    attr_accessor :y

    # Z coordinate (height)
    attr_accessor :z

    # Create new Proj4::Point object from coordinates.
    def initialize(x, y, z=0)
      @x = x
      @y = y
      @z = z
    end

    # Get longitude/x coordinate.
    def lon
      x
    end

    # Get latitude/y coordinate.
    def lat
      y
    end

    # Set longitude/x coordinate.
    def lon=(lon)
      @x = lon
    end

    # Set latitude/y coordinate.
    def lat=(lat)
      @y = lat
    end

  end

  # Abstract base class for several types of definitions: Proj4::Datum, Proj4::Ellipsoid, Proj4::PrimeMeridian, Proj4::ProjectionType, Proj4::Unit.
  #
  # Note that these classes only work if the version of the Proj.4 C library used is at least 449.
  class Def

    # Initialize function raises error. Definitions are always defined by the underlying Proj.4 library, you can't create them yourself.
    def initialize # :nodoc:
      raise TypeError, "You can't created objects of this type yourself."
    end

    # Get the definition with given id.
    def self.get(id)
      self.list.select{ |u| u.id == id }.first
    end

    # Compares definitions by comparing ids.
    #
    # call-seq: one == other -> true or false
    #
    def ==(other)
      self.id == other.id
    end

    # Compares definitions by comparing ids.
    #
    # call-seq: one <=> other -> -1, 0, 1
    #
    def <=>(other)
      self.id <=> other.id
    end

    # Stringify definition. Returns ID of this definition.
    #
    # call-seq: to_s -> String
    #
    def to_s
      id
    end

  end

  class Datum < Def

    # Returns datum definition as string in format '#<Proj4::Datum id="...", ellipse_id="...", defn="...", comments="...">'.
    #
    # call-seq: inspect -> String
    #
    def inspect
      "#<Proj4::Datum id=\"#{id}\", ellipse_id=\"#{ellipse_id}\", defn=\"#{defn}\", comments=\"#{comments}\">"
    end

  end

  class Ellipsoid < Def

    # Returns ellipsoid definition as string in format '#<Proj4::Ellipsoid id="...", major="...", ell="...", name="...">'.
    #
    # call-seq: inspect -> String
    #
    def inspect
      "#<Proj4::Ellipsoid id=\"#{id}\", major=\"#{major}\", ell=\"#{ell}\", name=\"#{name}\">"
    end

  end

  class PrimeMeridian < Def

    # Returns a prime meridian definition as string in format '#<Proj4::PrimeMeridian id="...", defn="...">'.
    #
    # call-seq: inspect -> String
    #
    def inspect
      "#<Proj4::PrimeMeridian id=\"#{id}\", defn=\"#{defn}\">"
    end

  end

  class ProjectionType < Def

    # Returns a projection type as string in format '#<Proj4::PrimeMeridian id="...", name="...">'.
    #
    # call-seq: inspect -> String
    #
    def inspect
      "#<Proj4::ProjectionType id=\"#{id}\", name=\"#{name}\">"
    end

    # Gets name of this projection type.
    #
    # call-seq: name -> String
    #
    def name
      descr.sub(/\n.*/m, '')
    end

  end

  class Unit < Def

    # Returns unit definition as string in format '#<Proj4::Unit id="...", to_meter="...", name="...">'.
    #
    # call-seq: inspect -> String
    #
    def inspect
      "#<Proj4::Unit id=\"#{id}\", to_meter=\"#{to_meter}\", name=\"#{name}\">"
    end

  end

end

