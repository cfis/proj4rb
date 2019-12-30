# encoding: UTF-8

require_relative './abstract_test'

class OperationTest < AbstractTest
  def test_get_all
    operations = Proj::Operation.list.map {|operation| operation.id}
    assert(operations.include?('aea'))
    assert(operations.include?('wintri'))
  end

  def test_one
    operation = Proj::Operation.get('rouss')
    assert_kind_of(Proj::Operation, operation)
    assert_equal('rouss', operation.id)
    assert_equal("Roussilhe Stereographic\n\tAzi, Ell", operation.description)
  end

  def test_equal
    e1 = Proj::Operation.get('rouss')
    e2 = Proj::Operation.get('rouss')
    assert(e1 == e2)
  end

  def test_failed_get
    operation = Proj::Operation.get('foo')
    assert_nil(operation)
  end
end
