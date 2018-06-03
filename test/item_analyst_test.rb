require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/item_analyst'
require 'pry'

class ItemAnalystTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants_test.csv",
            :items => "./data/items_test.csv",
            :invoices => "./data/invoices_test.csv",
            :invoice_items => "./data/invoice_items_test.csv", :transactions => "./data/transactions_test.csv"}
  @sales_engine = SalesEngine.from_csv(data)
  @sa = @sales_engine.analyst
  @itema = ItemAnalyst.new(@sa.items)
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
    mean = @itema.calculate_mean(@itema.items)
    expected = @itema.deviation_list_for_items(mean)
    assert_equal 10, expected.length
    assert_equal Array, expected.class
  end
end
