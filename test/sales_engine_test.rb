require_relative 'test_helper.rb'
require './lib/csv_parser'
require './lib/sales_engine'

require 'pry'

class SalesEngineTest < Minitest::Test
  def test_it_exists
    se = SalesEngine.new("something")
    assert_instance_of(SalesEngine, se)
  end

  def test_it_analyzes
    analyst = SalesEngine.analyst
    assert_instance_of(SalesAnalyst, analyst)
  end

  def test_from_csv_creates_merchant_repository
    merchants_hash = {:merchants => "./data/merchants.csv"}
    se = SalesEngine.from_csv(merchants_hash)
    assert_equal MerchantRepository, se.merchants.class
  end

  def test_from_csv_creates_item_repository
    items_hash = {:items => "./data/items.csv"}
    se = SalesEngine.from_csv(items_hash)
    assert_equal ItemRepository, se.items.class
  end
end
