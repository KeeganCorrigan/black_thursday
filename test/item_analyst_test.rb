# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/item_analyst'
require './lib/item'

class ItemAnalystTest < Minitest::Test
  def setup
    items =
      [
        Item.new(id: 1,
                 name: 'thing1',
                 description: 'stuff1',
                 unit_price: 1000,
                 merchant_id: 1,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 2,
                 name: 'thing2',
                 description: 'stuff2',
                 unit_price: 1000,
                 merchant_id: 1,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 3,
                 name: 'thing3',
                 description: 'stuff3',
                 unit_price: 1000,
                 merchant_id: 2,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 4,
                 name: 'thing4',
                 description: 'stuff4',
                 unit_price: 1500,
                 merchant_id: 2,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 5,
                 name: 'thing5',
                 description: 'stuff5',
                 unit_price: 1500,
                 merchant_id: 2,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 6,
                 name: 'thing6',
                 description: 'stuff6',
                 unit_price: 1500,
                 merchant_id: 3,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 7,
                 name: 'thing7',
                 description: 'stuff7',
                 unit_price: 2000,
                 merchant_id: 3,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 8,
                 name: 'thing8',
                 description: 'stuff8',
                 unit_price: 2000,
                 merchant_id: 3,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 9,
                 name: 'thing9',
                 description: 'stuff9',
                 unit_price: 2000,
                 merchant_id: 4,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23'),
        Item.new(id: 10,
                 name: 'thing10',
                 description: 'stuff10',
                 unit_price: 2500,
                 merchant_id: 4,
                 created_at: '2016-01-11',
                 updated_at: '1991-03-23')
      ]

    @itema = ItemAnalyst.new(items)
  end

  def test_it_exists
    assert_instance_of(ItemAnalyst, @itema)
  end

  def test_calculate_mean_for_items
    expected = @itema.calculate_mean(@itema.items)
    assert_equal 16.0, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_deviation_list_for_items
    expected = @itema.deviation_list_for_items(16.0)
    assert_equal 10, expected.length
    assert_equal Array, expected.class
  end
end
