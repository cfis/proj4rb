# encoding: UTF-8

require_relative './abstract_test'

class CoordinateMetadataTest < AbstractTest
  if Proj::Api::PROJ_VERSION >= Gem::Version.new('9.4.0')
    def test_create_static_crs
      crs = Proj::Crs.new("EPSG:4326")
      metadata = Proj::CoordinateMetadata.new(crs)
      assert(metadata)
      assert_equal(:PJ_TYPE_COORDINATE_METADATA, metadata.proj_type)
    end

    def test_create_with_epoch
      crs = Proj::Crs.new("EPSG:9000")
      metadata = Proj::CoordinateMetadata.new(crs, nil, 2025.0)
      assert(metadata)
      assert_in_delta(2025.0, metadata.epoch)
    end

    def test_create_with_context
      context = Proj::Context.new
      crs = Proj::Crs.new("EPSG:4326", context)
      metadata = Proj::CoordinateMetadata.new(crs, context)
      assert(metadata)
    end

    def test_epoch_static_crs
      crs = Proj::Crs.new("EPSG:4326")
      metadata = Proj::CoordinateMetadata.new(crs)
      assert_in_delta(0.0, metadata.epoch)
    end
  end
end
