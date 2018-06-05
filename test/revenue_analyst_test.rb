# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/revenue_analyst'
require 'pry'

class RevenueAnalystTest < Minitest::Test

  def setup
    data =
      {
        merchants: './data/merchants_test.csv',
        items: './data/items_test.csv',
        invoices: './data/invoices_test.csv',
        invoice_items: './data/invoice_items_test.csv',
        transactions: './data/transactions_test.csv'
      }
    @sales_engine = SalesEngine.from_csv(data)
    @sa = @sales_engine.analyst
    @ra = RevenueAnalyst.new(@sales_engine, @sa.invoices_by_merchant, @sa.transactions_by_invoice)
  end

  def test_it_exists
    assert_instance_of(RevenueAnalyst, @ra)
  end
end
