# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
  def setup
    merchants =
      [
        { id: 1,
          name: 'Shopin1901',
          created_at: '2010-12-10',
          updated_at: '2011-12-04' },
        { id: 2,
          name: 'Candisart',
          created_at: '2009-05-30',
          updated_at: '2010-08-29' },
        { id: 3,
          name: 'MiniatureBikez',
          created_at: '2010-03-30',
          updated_at: '2013-01-21' },
        { id: 4,
          name: 'LolaMarleys',
          created_at: '2008-06-09',
          updated_at: '2015-04-16' }
      ]
    @mr = MerchantRepository.new(merchants)
  end

  def test_it_exists
    assert_instance_of(MerchantRepository, @mr)
  end

  def test_it_creates_merchant_list
    assert_equal 'Shopin1901', @mr.merchants[0].name
  end

  def test_all_returns_array_of_all_merchants
    assert_equal 4, @mr.all.length
  end

  def test_it_finds_merchant_by_id
    id = 1
    expected = @mr.find_by_id(id)
    assert_equal 1, expected.id
    assert_equal 'Shopin1901', expected.name
  end

  def test_it_returns_nil_if_no_id
    id = 13
    expected = @mr.find_by_id(id)
    assert_nil expected
  end

  def test_it_finds_by_name
    name = 'Candisart'
    expected = @mr.find_by_name(name)
    assert_equal 2, expected.id
    assert_equal name, expected.name
  end

  def test_find_by_name_returns_nil
    name = 'le'
    expected = @mr.find_by_name(name)
    assert_nil expected
  end

  def test_find_by_name_case_insensitive
    name = 'CANDISART'
    expected = @mr.find_by_name(name)
    assert_equal 2, expected.id
  end

  def test_it_finds_all_by_name
    fragment = 'i'
    expected = @mr.find_all_by_name(fragment)
    assert_equal 3, expected.length
    assert expected.map(&:name).include?('Candisart')
  end

  def test_find_all_returns_empty_array
    name = 'Turing School of Software and Design'
    expected = @mr.find_all_by_name(name)
    assert_equal [], expected
  end

  def test_it_can_generate_new_id
    expected = @mr.generate_new_id
    assert_equal 5, expected
  end

  def test_it_can_create_merchant
    attributes = { name: 'Turing School of Software and Design' }
    @mr.create(attributes)
    expected = @mr.find_by_id(5)
    assert_equal 'Turing School of Software and Design', expected.name
  end

  def test_it_can_update_name
    attributes = { name: 'Turing School of Software and Design' }
    @mr.create(attributes)
    attributes = { name: 'TSSD' }
    @mr.update(5, attributes)
    expected = @mr.find_by_id(5)
    assert_equal 'TSSD', expected.name
    expected = @mr.find_by_name('Turing School of Software and Design')
    assert_nil expected
  end

  def test_it_can_delete_merchant
    @mr.delete(1)
    expected = @mr.find_by_id(1)
    assert_nil expected
  end

  def test_delete_on_unknown_merchant_does_nothing
    @mr.delete(14)
    expected = @mr.find_by_id(14)
    assert_nil expected
  end
end
