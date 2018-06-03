require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/merchant_item_analyst'
require 'pry'

class MerchantItemAnalystTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants_test.csv",
            :items => "./data/items_test.csv",
            :invoices => "./data/invoices_test.csv",
            :invoice_items => "./data/invoice_items_test.csv", :transactions => "./data/transactions_test.csv"}
  @sales_engine = SalesEngine.from_csv(data)
  @sa = @sales_engine.analyst
  @mia = MerchantItemAnalyst.new(@sa.items_by_merchant, @sa.merchants, @sa.items)
  end

  def test_it_exists
    assert_instance_of(MerchantItemAnalyst, @mia)
  end

  def test_it_has_attributes
    assert_equal 4, @mia.items_by_merchant.length
    assert_equal 4, @mia.merchants.length
    assert_equal 10, @mia.items.length
  end

  def test_calculate_average_price
    merchant_id = 1
    expected = @mia.calculate_average_price(merchant_id)
    assert_equal 10.0, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_get_list_of_high_item_count_merchant_ids
    expected = @mia.list_of_high_item_count_merchant_ids
    assert_equal Array, expected.class
    assert_equal 4, expected.length
  end
end
