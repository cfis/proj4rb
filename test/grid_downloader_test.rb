# encoding: UTF-8

require_relative './abstract_test'

class GridDownloaderTest < AbstractTest
  def setup
    super
    # Make sure downloader callbacks are not GCed
    GC.stress = true
  end

  def teardown
    super
    GC.stress = false
  end

  def test_downloader
    context = Proj::Context.new
    context.network_enabled = true
    puts context.url

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
