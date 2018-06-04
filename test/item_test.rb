# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/item_repository'

class ItemTest < Minitest::Test
  def setup
    @information =
      {
        id: 1234,
        name: 'test',
        description: 'stuff',
        unit_price: 3200,
        merchant_id: 12334141,
        created_at: Time.now,
        updated_at: '2007-06-04 21:35:10 UTC'
      }
  end

  def test_it_exists
    item = Item.new(@information)
    assert_instance_of(Item, item)
  end

  def test_it_has_attributes
    item = Item.new(@information)
    assert_equal 1234, item.id
    assert_equal 'test', item.name
    assert_equal 'stuff', item.description
    assert_equal BigDecimal, item.unit_price.class
    assert_equal 12334141, item.merchant_id
  end

  def test_convert_time
    item = Item.new(@information)
    assert_equal Time, item.updated_at.class
  end

  def test_unit_price_to_dollars
    item = Item.new(@information)
    assert_equal 32.00, item.unit_price_to_dollars
  end
end
