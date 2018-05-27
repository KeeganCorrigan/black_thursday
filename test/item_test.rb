require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/item_repository'
require 'pry'

class ItemTest < Minitest::Test
  def test_it_exists
    information = {
                  id: 1234,
                  name: "test",
                  description: "stuff",
                  unit_price: 3200,
                  merchant_id: 12334141,
                  created_at: nil,
                  updated_at: nil
                    }
    item = Item.new(information)
    assert_instance_of(Item, item)
  end

  def test_it_has_attributes
    information = {
                  id: 1234,
                  name: "test",
                  description: "stuff",
                  unit_price: 3200,
                  merchant_id: 12334141,
                  created_at: nil,
                  updated_at: nil
                    }
    item = Item.new(information)
    assert_equal 1234, item.id
    assert_equal "test", item.name
    assert_equal "stuff", item.description
    assert_equal 3200, item.unit_price
    assert_equal 12334141, item.merchant_id
  end
end
