# encoding: UTF-8

require_relative './abstract_test'

class GridTest < AbstractTest
  def test_grid
    database = Proj::Database.new(Proj::Context.current)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    assert_equal("au_icsm_GDA94_GDA2020_conformal.tif", grid.name)
    assert(grid.full_name.empty?)
    assert(grid.package_name.empty?)
    assert_equal("https://cdn.proj.org/au_icsm_GDA94_GDA2020_conformal.tif", grid.url.to_s)
    assert(grid.downloadable?)
    assert(grid.open_license?)
    refute(grid.available?)
  end

  def test_grid_proj6_name
    database = Proj::Database.new(Proj::Context.current)
    grid = database.grid("GDA94_GDA2020_conformal.gsb")

    assert_equal("GDA94_GDA2020_conformal.gsb", grid.name)
    assert(grid.full_name.empty?)
    assert(grid.package_name.empty?)
    assert_instance_of(URI::HTTPS, grid.url)
    assert_equal("https://cdn.proj.org/au_icsm_GDA94_GDA2020_conformal.tif", grid.url.to_s)
    assert(grid.downloadable?)
    assert(grid.open_license?)
    refute(grid.available?)
  end

  def test_downloaded_network_disabled
    context = Proj::Context.new
    context.network_enabled = false

    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)
    refute(grid.downloaded?)
  end

  def test_downloaded_network_enabled
    context = Proj::Context.new
    context.network_enabled = true

    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)
    refute(grid.downloaded?)
  end

  def test_download
    context = Proj::Context.new
    context.network_enabled = true

    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)
    refute(grid.path)

    begin
      grid.download
      assert(grid.path)
      assert(grid.downloaded?)
    ensure
      grid.delete
    end
  end

  def test_download_with_progress
    context = Proj::Context.new
    context.network_enabled = true

    database = Proj::Database.new(context)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    progress_values = Array.new
    begin
      downloaded = grid.download do |progress|
        progress_values << progress
      end
      assert(downloaded)
    ensure
      grid.delete
    end

    assert(progress_values.count > 1)
    assert(progress_values.include?(1.0))
  end

  def test_download_with_progress_cancel
    context = Proj::Context.new
    context.network_enabled = true

    database = Proj::Database.new(context)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    progress_values = Array.new
    begin
      downloaded = grid.download do |progress|
        progress_values << progress
        # Cancel download
        false
      end
      refute(downloaded)
    ensure
      grid.delete
    end

    assert_equal(1, progress_values.count)
    refute(progress_values.include?(1.0))
  end

  def test_grid_info
    context = Proj::Context.new
    context.network_enabled = true
    grid = Proj::Grid.new("dk_sdfe_dvr90.tif", context)

    begin
      assert(grid.info.filename.empty?)
      #assert_equal("dk_sdfe_dvr90.tif", grid.info.gridname)
      # assert_equal("gtiff", grid.info.format)
      # assert_in_delta(0, grid.info.lower_left[:lam])
      # assert_in_delta(0, grid.info.lower_left[:phi])
      # assert_in_delta(0, grid.info.upper_right[:lam])
      # assert_in_delta(0, grid.info.upper_right[:phi])
      # assert_in_delta(0, grid.info.size_lon)
      # assert_in_delta(0, grid.info.size_lat)
      # assert_in_delta(0, grid.info.cell_size_lon)
      # assert_in_delta(0, grid.info.cell_size_lat)
    ensure
      grid.delete
    end
  end

  if proj9?
    def test_grid_invalid
      database = Proj::Database.new(Proj::Context.current)
      grid = database.grid("invalid")
      refute(grid)
    end
  else
    def test_grid_invalid
      database = Proj::Database.new(Proj::Context.current)
      error = assert_raises(Proj::Error) do
        database.grid("invalid")
      end
      assert_equal("Invalid value for an argument", error.to_s)
      refute(grid)
    end
  end
end
