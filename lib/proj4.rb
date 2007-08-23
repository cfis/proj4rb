ENV['PROJ_LIB'] = File.dirname(__FILE__) + '/../data'
require 'projrb'

module Proj4

    # The UV class holds one coordinate pair (either lon/lat or x/y depending on projection).
    class UV

        # Compare to UV instances, they are equal if both coordinates are equal, respectively.
        def ==(uv)
            self.u == uv.u && self.v == uv.v
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

    end

end

