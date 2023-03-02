# encoding: UTF-8

require_relative './abstract_test'

class GridTest < AbstractTest
  def test_grid_invalid
    database = Proj::Database.new(Proj::Context.current)
    grid = database.grid("invalid")
    refute(grid)
  end

  def test_grid
    database = Proj::Database.new(Proj::Context.current)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    assert_equal("au_icsm_GDA94_GDA2020_conformal.tif", grid.name)
    assert(grid.full_name.empty?)
    assert(grid.package_name.empty?)
    assert_equal("https://cdn.proj.org/au_icsm_GDA94_GDA2020_conformal.tif", grid.url)
    assert(grid.downloadable)
    assert(grid.open_license)
    refute(grid.available)
  end

  def test_grid_proj6_name
    database = Proj::Database.new(Proj::Context.current)
    grid = database.grid("GDA94_GDA2020_conformal.gsb")

    assert_equal("GDA94_GDA2020_conformal.gsb", grid.name)
    assert(grid.full_name.empty?)
    assert(grid.package_name.empty?)
    assert_equal("https://cdn.proj.org/au_icsm_GDA94_GDA2020_conformal.tif", grid.url)
    assert(grid.downloadable)
    assert(grid.open_license)
    refute(grid.available)
  end
end