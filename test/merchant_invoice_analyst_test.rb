require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/merchant_invoice_analyst'
require 'pry'

class MerchantInvoiceAnalystTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants_test.csv",
            :items => "./data/items_test.csv",
            :invoices => "./data/invoices_test.csv",
            :invoice_items => "./data/invoice_items_test.csv", :transactions => "./data/transactions_test.csv"}
  @sales_engine = SalesEngine.from_csv(data)
  @sa = @sales_engine.analyst
  @mia = MerchantInvoiceAnalyst.new(@sa.invoices_by_merchant, @sa.merchants, @sa.invoices)
  end

  def test_it_exists
    assert_instance_of(MerchantInvoiceAnalyst, @mia)
  end

  def test_it_has_attributes
    assert_equal 4, @mia.invoices_by_merchant.length
    assert_equal 4, @mia.merchants.length
    assert_equal 10, @mia.invoices.length
  end

  def test_high_invoice_count_merchants
    expected = @mia.high_invoice_count_merchants
    assert_equal 0, expected.length
  end

  def test_low_invoice_count_merchants
    expected = @mia.low_invoice_count_merchants
    assert_equal 0, expected.length
  end
end
