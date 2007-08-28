ENV['PROJ_LIB'] = File.dirname(__FILE__) + '/../data'
require 'projrb'

# Ruby bindings for the Proj.4 cartographic projection library.
module Proj4

    # Base class for all Proj.4 exceptions. Subclasses with the name <errorname>Error are available for each exception.
    class Error < StandardError

        # List of all Proj.4 errors.
        #--
        # (This list is created from the one in pj_strerrno.c in the Proj.4 distribution.)
        #++
        ERRORS = %w{Unknown NoArgsInInitList NoOptionsInInitFile NoColonInInitString ProjectionNotNamed UnknownProjectionId EffectiveEccentricityEq1 UnknownUnitConversionId InvalidBooleanParamArgument UnknownEllipticalParameterName ReciprocalFlatteningIsZero RadiusReferenceLatitudeGt90 SquaredEccentricityLessThanZero MajorAxisOrRadiusIsZeroOrNotGiven LatitudeOrLongitudeExceededLimits InvalidXOrY ImproperlyFormedDMSValue NonConvergentInverseMeridinalDist NonConvergentInversePhi2 AcosOrAsinArgTooBig ToleranceConditionError ConicLat1EqMinusLat2 Lat1GreaterThan90 Lat1IsZero LatTsGreater90 NoDistanceBetweenControlPoints ProjectionNotSelectedToBeRotated WSmallerZeroOrMSmallerZero LsatNotInRange PathNotInRange HSmallerZero KSmallerZero Lat0IsZeroOr90OrAlphaIsZero Lat1EqLat2OrLat1IsZeroOrLat2Is90 EllipticalUsageRequired InvalidUTMZoneNumber ArgsOutOfRangeForTchebyEval NoProjectionToBeRotated FailedToLoadNAD2783CorrectionFile BothNAndMMustBeSpecdAndGreaterZero NSmallerZeroOrNGreaterOneOrNotSpecified Lat1OrLat2NotSpecified AbsoluteLat1EqLat2 Lat0IsHalfPiFromMeanLat UnparseableCoordinateSystemDefinition GeocentricTransformationMissingZOrEllps UnknownPrimeMeridianConversionId}

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
            raise eval("#{error(errnum)}Error"), strerrno(-errnum), caller[0..-1]
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

    # The UV class holds one coordinate pair. Can be either lon/lat or x/y.
    class UV

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

    # The Projection class represents a geographical projection.
    class Projection

        # Convenience function for calculating a forward projection with degrees instead of radians.
        def forwardDeg(uv)
            forward(Proj4::UV.new( uv.u * Proj4::DEG_TO_RAD, uv.v * Proj4::DEG_TO_RAD))
        end

        # Convenience function for calculating an inverse projection with the result in degrees instead of radians.
        def inverseDeg(uv)
            uvd = inverse(uv)
            Proj4::UV.new( uvd.u * Proj4::RAD_TO_DEG, uvd.v * Proj4::RAD_TO_DEG)
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

    end

    # This class represents a point in space in either lon/lat or projected coordinates.
    class Point

        # x coordinate or longitude
        attr_accessor :x

        # y coordinate or latitude
        attr_accessor :y

        # z coordinate
        attr_accessor :z

        def initialize(x, y, z=0)
            @x = x
            @y = y
            @z = z
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

end

