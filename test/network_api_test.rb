# encoding: UTF-8

require_relative './abstract_test'

class NetworkApiTest < AbstractTest
  def setup
    super
    # Make sure downloader callbacks are not GCed
    #GC.stress = true
  end

  def teardown
    super
    GC.stress = false
  end

  def test_download
    skip "This test causes a segfault due to the way Proj cleans up on shutdown"

    context = Proj::Context.new
    context.network_enabled = true

    # Create a grid
    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)
    grid.delete

    context.cache.clear

    # Install custom network api
    context.set_network_api(Proj::NetworkApiImpl)

    conversion = Proj::Conversion.new(<<~EOS, context)
          +proj=pipeline
          +step +proj=unitconvert +xy_in=deg +xy_out=rad
          +step +proj=vgridshift +grids=dk_sdfe_dvr90.tif +multiplier=1
          +step +proj=unitconvert +xy_in=rad +xy_out=deg
        EOS

    coord = Proj::Coordinate.new(lon: 12, lat: 56, z: 0)
    new_coord = conversion.forward(coord)
    assert_in_delta(12, new_coord.lon)
    assert_in_delta(56, new_coord.lat)
    assert_in_delta(36.5909996032715, new_coord.z, 1e-10)
  end
end
