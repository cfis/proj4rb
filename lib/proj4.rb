ENV['PROJ_LIB'] = File.dirname(__FILE__) + '/../data'
require 'projrb'

# Ruby bindings for the Proj.4 cartographic projection library (http://proj.maptools.org).
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
            raise eval("#{error(errnum.abs)}Error"), strerrno(-(errnum.abs)), caller[0..-1]
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
    class Projection

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
        def forward(point)
            forward!(point.dup)
        end

        # Convenience function for calculating a forward projection with degrees instead of radians.
        def forwardDeg(point)
            forwardDeg!(point.dup)
        end

        # Convenience function for calculating a forward projection with degrees instead of radians.
        # This version works in-place, i.e. the point objects content is overwritten.
        def forwardDeg!(point)
            point.x *= Proj4::DEG_TO_RAD
            point.y *= Proj4::DEG_TO_RAD
            forward!(point)
        end

        # Inverse projection of a point. Returns a copy of the point object with coordinates projected.
        def inverse(point)
            inverse!(point.dup)
        end

        # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
        def inverseDeg(point)
            inverseDeg!(point.dup)
        end

        # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
        # This version works in-place, i.e. the point objects content is overwritten.
        def inverseDeg!(point)
            inverse!(point)
            point.x *= Proj4::RAD_TO_DEG
            point.y *= Proj4::RAD_TO_DEG
            point
        end

        # Transforms a point from one projection to another. The second
        # parameter is either a Proj4::Point object or you can use any
        # object which responds to the x, y, z read and write accessor
        # methods. (In fact you don't even need the z accessor methods,
        # 0 is assumed if they don't exist).  This is the non-destructive
        # variant of the method, i.e. it will first create a copy of
        # your point object by calling its +dup+ method.
        #
        # call-seq: transform(destinationProjection, point) -> point
        #
        def transform(otherProjection, point)
            transform!(otherProjection, point.dup)
        end

        # Transforms all points in a collection 'in place' from one projection
        # to another. The +collection+ object must implement the +each+
        # method for this to work.
        def transform_all!(otherProjection, collection)
            collection.each do |point|
                transform!(otherProjection, point)
            end
            collection
        end

        # Transforms all points in a collection from one projection to
        # another. The +collection+ object must implement the +each+,
        # +clear+, and << methods (just like an Array) for this to work.
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

    # The UV class holds one coordinate pair. Can be either lon/lat or x/y.
    # This class is deprecated and it will disappear in a later version of this
    # library. Use Proj4::Point instead (or any other class supporting x, y read and
    # write accessor method.
    class UV

        attr_accessor :x, :y

        def initialize(x, y)
            if ! x.kind_of?(Float) or ! y.kind_of?(Float)
                raise TypeError
            end
            @x = x
            @y = y
        end

        # get u(x) coordinate
        def u
            x
        end

        # get v(y) coordinate
        def v
            y
        end

        # set u(x) coordinate
        def u=(u)
            @x = u
        end

        # set v(y) coordinate
        def v=(v)
            @y = v
        end

        # Compare to UV instances, they are equal if both coordinates are equal, respectively.
        #
        # call-seq: uv == other -> true or false
        #
        def ==(uv)
            self.u == uv.u && self.v == uv.v
        end

        # Create string in format 'x,y'.
        #
        # call-seq: to_s -> String
        #
        def to_s
            "#{u},#{v}"
        end

    end

end

