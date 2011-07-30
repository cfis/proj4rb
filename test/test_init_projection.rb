# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class InitProjectionTest < Test::Unit::TestCase

  def setup
    # NAD27(76) / UTM zone 17N
    # <2029> +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs  no_defs <>
    @epsg2029i = ['init=epsg:2029']
    @epsg2029x = ['proj=utm', 'zone=17', 'ellps=clrk66', 'units=m', 'no_defs'].sort

    @nad = ' +init=epsg:2029 +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs'
  end

  def test_arg_fail
    assert_raise ArgumentError do
      Proj4::Projection._parse_init_parameters()
    end
    assert_raise ArgumentError do
      Proj4::Projection._parse_init_parameters(nil)
    end
    assert_raise ArgumentError do
      Proj4::Projection._parse_init_parameters(1)
    end
  end

  def test_arg_string
    args = Proj4::Projection._parse_init_parameters('init=epsg:2029')
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters('  proj=utm zone=17 ellps=clrk66 units=m no_defs  ')
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_string_with_plus
    args = Proj4::Projection._parse_init_parameters('+init=epsg:2029')
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters('+proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs')
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_array
    args = Proj4::Projection._parse_init_parameters(['init=epsg:2029'])
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters(['proj=utm', 'zone=17', 'ellps=clrk66', 'units=m', 'no_defs'])
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_array_with_plus
    args = Proj4::Projection._parse_init_parameters(['+init=epsg:2029'])
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters(['+proj=utm', '+zone=17', '+ellps=clrk66', '+units=m', '+no_defs'])
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_hash_with_string
    args = Proj4::Projection._parse_init_parameters( {'init' => 'epsg:2029'} )
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters( {'proj' => 'utm', 'zone' => '17', 'ellps' => 'clrk66', 'units' => 'm', 'no_defs' => nil} )
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_hash_with_symbol
    args = Proj4::Projection._parse_init_parameters( {:init => 'epsg:2029'} )
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters( {:proj => 'utm', :zone => '17', :ellps => 'clrk66', :units => 'm', :no_defs => nil} )
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_hash_with_symbol_simple
    args = Proj4::Projection._parse_init_parameters( :init => 'epsg:2029' )
    assert_equal @epsg2029i, args
    args = Proj4::Projection._parse_init_parameters( :proj => 'utm', :zone => '17', :ellps => 'clrk66', :units => 'm', :no_defs => nil )
    assert_equal @epsg2029x, args.sort
  end

  def test_arg_projection
    proj = Proj4::Projection.new(['init=epsg:2029'])
    args = Proj4::Projection._parse_init_parameters(proj)
    assert_equal [@epsg2029i, @epsg2029x].flatten.sort, args.sort
  end

  def test_init_arg_string
    proj = Proj4::Projection.new('+init=epsg:2029')
    assert_equal @nad, proj.getDef
  end

  def test_init_arg_array
    proj = Proj4::Projection.new(['init=epsg:2029'])
    assert_equal @nad, proj.getDef
  end

  def test_init_arg_hash
    proj = Proj4::Projection.new( :proj => 'utm', 'zone' => '17', '+ellps' => 'clrk66', :units => 'm', :no_defs => nil )
    assert_equal @epsg2029x, proj.getDef.strip.split(' ').collect{ |a| a.sub(/^\+/, '') }.sort
  end

  def test_init_arg_fail
    assert_raise Proj4::UnknownProjectionIdError do
      Proj4::Projection.new( :proj => 'xxxx' )
    end
    assert_raise Proj4::ProjectionNotNamedError do
      Proj4::Projection.new( :foo => 'xxxx' )
    end
  end

end

