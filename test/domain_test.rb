# encoding: UTF-8

require_relative './abstract_test'

class DomainTest < AbstractTest
  def test_domain_count
    crs = Proj::Crs.new('EPSG:4326')
    count = Proj::Domain.count(crs)
    assert_kind_of(Integer, count)
    assert_operator(count, :>=, 1)
  end

  def test_domains
    crs = Proj::Crs.new('EPSG:4326')
    domains = Proj::Domain.domains(crs)
    assert_kind_of(Array, domains)
    refute_empty(domains)

    domain = domains.first
    assert_kind_of(Proj::Domain, domain)
    assert_kind_of(String, domain.scope)
    assert_kind_of(Proj::Area, domain.area_of_use)
  end

  def test_domain_scope
    crs = Proj::Crs.new('EPSG:4326')
    domain = Proj::Domain.domains(crs).first
    assert_equal("Horizontal component of 3D system.", domain.scope)
  end

  def test_domain_area_of_use
    crs = Proj::Crs.new('EPSG:4326')
    domain = Proj::Domain.domains(crs).first
    area = domain.area_of_use
    assert_equal('World.', area.name)
    assert_in_delta(-180.0, area.west_lon_degree, 0.1)
    assert_in_delta(-90.0, area.south_lat_degree, 0.1)
    assert_in_delta(180.0, area.east_lon_degree, 0.1)
    assert_in_delta(90.0, area.north_lat_degree, 0.1)
  end

  def test_domains_matches_area_of_use
    crs = Proj::Crs.new('EPSG:4326')
    domain = Proj::Domain.domains(crs).first
    area = crs.area_of_use
    assert_equal(area.name, domain.area_of_use.name)
    assert_in_delta(area.west_lon_degree, domain.area_of_use.west_lon_degree, 0.001)
    assert_in_delta(area.south_lat_degree, domain.area_of_use.south_lat_degree, 0.001)
    assert_in_delta(area.east_lon_degree, domain.area_of_use.east_lon_degree, 0.001)
    assert_in_delta(area.north_lat_degree, domain.area_of_use.north_lat_degree, 0.001)
  end

  def test_domains_matches_scope
    crs = Proj::Crs.new('EPSG:4326')
    domain = Proj::Domain.domains(crs).first
    assert_equal(crs.scope, domain.scope)
  end

  def test_pj_object_domains
    crs = Proj::Crs.new('EPSG:4326')
    domains = crs.domains
    assert_kind_of(Array, domains)
    refute_empty(domains)
    assert_kind_of(Proj::Domain, domains.first)
  end

  def test_domains_noop
    conversion = Proj::Conversion.new("+proj=noop")
    domains = Proj::Domain.domains(conversion)
    assert_empty(domains)
  end
end
