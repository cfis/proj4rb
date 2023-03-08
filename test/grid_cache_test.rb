# encoding: UTF-8

require_relative './abstract_test'

class GridCacheTest < AbstractTest
  def download(grid)
    begin
      grid.download
    ensure
      grid.delete
    end
  end

  def test_clear
    context = Proj::Context.new
    context.network_enabled = true
    database = Proj::Database.new(context)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    cache_path = File.join(context.user_directory, "cache.db")

    # Download the file to create the cache
    download(grid)

    assert(File.exist?(cache_path))
    cache = Proj::GridCache.new(context)
    cache.clear
    refute(File.exist?(cache_path))
  end

  def test_disable
    context = Proj::Context.new
    context.network_enabled = true
    context.cache.enabled = false

    database = Proj::Database.new(context)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    cache_path = File.join(context.user_directory, "cache.db")
    File.delete(cache_path) if File.exist?(cache_path)
    refute(File.exist?(cache_path))

    # Download the file to create the cache
    download(grid)

    refute(File.exist?(cache_path))
  end

  def test_set_path
    context = Proj::Context.new
    context.network_enabled = true
    database = Proj::Database.new(context)
    grid = database.grid("au_icsm_GDA94_GDA2020_conformal.tif")

    # Custom path
    cache_path = context.cache.path = File.join(Dir.tmpdir, "proj_cache_test.db")
    refute(File.exist?(cache_path))

    # Download the file to create the cache
    download(grid)

    assert(File.exist?(cache_path))

    context.cache.clear
    refute(File.exist?(cache_path))
  end

  def test_ttl
    context = Proj::Context.new
    context.cache.ttl = 60
    assert(true)
  end

  def test_max_size
    context = Proj::Context.new
    context.cache.max_size = 100
    assert(true)
  end
end
