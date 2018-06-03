require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/invoice_analyst'
require 'pry'

class InvoiceAnalystTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants_test.csv",
            :items => "./data/items_test.csv",
            :invoices => "./data/invoices_test.csv",
            :invoice_items => "./data/invoice_items_test.csv", :transactions => "./data/transactions_test.csv"}
  @sales_engine = SalesEngine.from_csv(data)
  @sa = @sales_engine.analyst
  @ia = InvoiceAnalyst.new(@sa.invoices)
  end

  def test_it_has_attributes
    assert_equal 10, @ia.invoices.length
  end

  def test_invoices_created_by_day
    expected = @ia.invoices_created_by_day
    assert_equal Array, expected.class
    assert_equal 10, expected.length
  end

  def test_count_invoices_created_by_day
    expected = @ia.count_invoices_created_by_day
    assert_equal Hash, expected.class
    assert_equal 4, expected.length
  end
end
