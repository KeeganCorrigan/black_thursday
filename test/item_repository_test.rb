require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/item_repository'
require 'pry'

class ItemRepositoryTest < Minitest::Test
  def setup
    item_info = {:items => "./data/items.csv"}
    se = SalesEngine.from_csv(item_info)
    @mi = se.items
  end

  def test_it_exists
    assert_instance_of(ItemRepository, @mi)
  end

  def test_it_creates_items_list
    assert_equal "510+ RealPush Icon Set", @mi.items[0].name
  end
end
