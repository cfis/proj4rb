ENV['PROJ_LIB'] = File.dirname(__FILE__) + '/../data'
require 'projrb'

module Proj4

    class Projection

        # convenience function for calculating a forward projection with degrees instead of radians
        def forwardDeg(uv)
            forward(Proj4::UV.new( uv.u * Proj4::DEG_TO_RAD, uv.v * Proj4::DEG_TO_RAD))
        end

        # convenience function for calculating an inverse projection with the result in degrees instead of radians
        def inverseDeg(uv)
            uvd = inverse(uv)
            Proj4::UV.new( uvd.u * Proj4::RAD_TO_DEG, uvd.v * Proj4::RAD_TO_DEG)
        end

    end

end

