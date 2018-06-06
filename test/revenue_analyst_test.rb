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

  def test_group_invoice_items_by_invoice_id
    assert_equal 10, @ra.group_invoice_items_by_invoice_id.length
  end

  def test_find_item_quantities_sold_by_merchant
    invoice_per_merchant = @ra.find_paid_invoices_per_merchant(1)
    invoice_id = @ra.find_invoices_by_invoice_id(invoice_per_merchant)
    expected = @ra.find_item_quantities_sold_by_merchant(invoice_id)
    assert_equal Hash, expected.class
    assert_equal 9, expected[2]
  end

  def test_find_paid_invoices_per_merchant
    expected = @ra.find_paid_invoices_per_merchant(1)
    assert_equal 2, expected.length
    assert_equal Invoice, expected.first.class
  end

  def test_merchants_by_revenue
    expected = @ra.merchants_by_revenue
    assert_equal Hash, expected.class
    assert_equal 2780.91, expected[1].to_f
    assert_equal 8395.52, expected[2].to_f
  end

  def test_find_item_revenue_sold_by_merchant
    invoice_per_merchant = @ra.find_paid_invoices_per_merchant(1)
    invoice_id = @ra.find_invoices_by_invoice_id(invoice_per_merchant)
    expected = @ra.find_item_revenue_sold_by_merchant(invoice_id)
    assert_equal 681.75, expected[1]
  end

  def test_sort_merchants_by_revenue
    expected = @ra.sort_merchants_by_revenue
    assert_equal 74.36, expected[4]
    assert_equal 2780.91, expected[1]
  end

  def test_calculate_highest_revenue_item_by_merchant
    items = { '1': 681.75, '2': 987.60 }
    expected = @ra.calculate_highest_revenue_item_by_merchant(items)
    assert_equal 987.60, expected[1]
    assert_equal 2, expected.length
  end

  def test_find_invoices_by_invoice_id
    invoice_per_merchant = @ra.find_paid_invoices_per_merchant(1)
    expected = @ra.find_invoices_by_invoice_id(invoice_per_merchant)
    assert_equal Array, expected.class
    assert_equal InvoiceItem, expected.first.class
  end
end
