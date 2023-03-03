# encoding: UTF-8

require_relative './abstract_test'

class GridDownloaderTest < AbstractTest
  def setup
    super
    # Make sure downloader callbacks are not GCed
    #    GC.stress = true
  end

  def teardown
    super
    GC.stress = false
  end

  def test_read
    context = Proj::Context.new
    context.network_enabled = true

    # Create a grid
    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)
    puts grid.path
    puts context.user_directory

    begin
      grid.download
      assert(grid.downloaded?)
      context.network_enabled = false

      conversion = Proj::Conversion.new(<<~EOS, context)
            +proj=pipeline
            +step +proj=unitconvert +xy_in=deg +xy_out=rad
            +step +proj=vgridshift +grids=dk_sdfe_dvr90.tif +multiplier=1
            +step +proj=unitconvert +xy_in=rad +xy_out=deg
          EOS

      # Create custom downloader to download the grid
      downloader = Proj::GridDownloader.new(context)

      coord = Proj::Coordinate.new(long: 12, lat: 56, z: 0)
      new_coord = conversion.forward(coord)
      assert_in_delta(12, coord.long)
      assert_in_delta(56, coord.lat)
      assert_in_delta(0, coord.z)
    ensure
      # grid.delete
    end
  end

  def test_write
    context = Proj::Context.new
    context.network_enabled = true

    # Create a grid
    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)
    grid.delete

    begin
      # Create custom downloader to download the grid
      downloader = Proj::GridDownloader.new(context)
      grid.download

      assert(grid.downloaded?)
    ensure
      # grid.delete
    end
  end
end
