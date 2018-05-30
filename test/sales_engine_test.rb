require_relative 'test_helper.rb'
require './lib/csv_parser'
require './lib/sales_engine'

require 'pry'

class SalesEngineTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants.csv", :items => "./data/items.csv", :invoices => "./data/invoices.csv", :invoice_items => "./data/invoice_items.csv", :transactions => "./data/transactions.csv", :customers => "./data/customers.csv"}
    @sales_engine = SalesEngine.from_csv(data)
  end

  def test_it_exists
    assert_instance_of(SalesEngine, @sales_engine)
  end

  def test_it_analyzes
    analyst = @sales_engine.analyst
    assert_instance_of(SalesAnalyst, analyst)
  end

  def test_it_loads_data_files
    assert_equal ItemRepository, @sales_engine.items.class
    assert_equal MerchantRepository, @sales_engine.merchants.class
    assert_equal InvoiceRepository, @sales_engine.invoices.class
    assert_equal InvoiceItemRepository, @sales_engine.invoice_items.class
    assert_equal TransactionRepository, @sales_engine.transactions.class
    assert_equal CustomerRepository, @sales_engine.customers.class
  end
end
