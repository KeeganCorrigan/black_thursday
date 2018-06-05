# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/merchant_item_analyst'

class SalesAnalystTest < Minitest::Test
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
    @mia = MerchantItemAnalyst.new(@sa.merchants, @sa.items)
    @items_by_merchant = @mia.items_by_merchant
  end

  def test_it_exists
    assert_instance_of(SalesAnalyst, @sa)
  end

  def test_it_gets_items
    assert_equal 10, @sa.items.length
  end

  def test_it_gets_merchants
    assert_equal 4, @sa.merchants.length
  end

  def test_it_gets_invoice_items
    assert_equal 10, @sa.invoice_items.length
  end

  def test_group_invoice_items_by_invoice_id
    assert_equal 10, @sa.group_invoice_items_by_invoice_id.length
  end

  def test_average_items_per_merchant
    assert_equal 2.5, @sa.average_items_per_merchant
    assert_equal Float, @sa.average_items_per_merchant.class
  end

  def test_list_of_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@items_by_merchant, mean)
    assert_equal Array, deviations.class
    assert_equal 4, deviations.length
    assert_equal(deviations[0], -0.5)
  end

  def test_square_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@items_by_merchant, mean)
    square_deviations = @sa.square_deviations(deviations)
    assert_equal Array, square_deviations.class
    assert_equal 4, square_deviations.length
    assert_equal 0.25, square_deviations[0]
  end

  def test_sum_of_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@items_by_merchant, mean)
    square_deviations = @sa.square_deviations(deviations)
    sum = @sa.sum_of_deviations(square_deviations)
    assert_equal Float, sum.class
    assert_equal 1.0, sum
  end

  def test_average_items_per_merchant_standard_deviation
    standard_deviation = @sa.average_items_per_merchant_standard_deviation
    assert_equal 0.577, standard_deviation
    assert_equal Float, standard_deviation.class
  end

  def test_merchants_with_high_item_count
    assert_equal 4, @sa.merchants_with_high_item_count.length
    assert_equal Merchant, @sa.merchants.first.class
  end

  def test_average_item_price_for_merchant
    merchant_id = 3
    expected = @sa.average_item_price_for_merchant(merchant_id)
    assert_equal 18.33, expected
    assert_equal BigDecimal, expected.class
  end

  def test_average_average_price_per_merchant
    expected = @sa.average_average_price_per_merchant
    assert_equal 16.042, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_standard_deviation_for_items
    expected = @sa.standard_deviation_for_items
    assert_equal 5.16, expected
  end

  def test_golden_items
    expected = @sa.golden_items
    assert_equal 7, expected.length
    assert_equal Item, expected.first.class
  end

  def test_group_invoices_by_merchant
    expected = @sa.invoices_by_merchant
    assert_equal 4, expected.length
  end

  def test_average_invoices_per_merchant
    expected = @sa.average_invoices_per_merchant
    assert_equal 2.5, expected
    assert_equal Float, expected.class
  end

  def test_average_invoices_per_merchant_standard_deviation
    expected = @sa.average_invoices_per_merchant_standard_deviation
    assert_equal 0.577, expected
    assert_equal Float, expected.class
  end

  def test_top_merchants_by_invoice_count
    expected = @sa.top_merchants_by_invoice_count
    assert_equal 0, expected.length
    assert_equal Array, expected.class
  end

  def test_bottom_merchants_by_invoice_count
    expected = @sa.bottom_merchants_by_invoice_count
    assert_equal 0, expected.length
  end

  def test_top_days_by_invoice_count
    expected = @sa.top_days_by_invoice_count
    assert_equal 1, expected.length
    assert_equal 'Friday', expected.first
  end

  def test_invoice_status
    expected = @sa.invoice_status(:pending)
    assert_equal 60.0, expected.to_f
    expected = @sa.invoice_status(:shipped)
    assert_equal 40.0, expected.to_f
    expected = @sa.invoice_status(:returned)
    assert_equal 0.0, expected.to_f
  end

  def test_invoice_paid_in_full
    assert @sa.invoice_paid_in_full?(1)
  end

  def test_invoice_total
    assert_equal 681.75, @sa.invoice_total(1).to_f
  end

  def test_find_invoice_ids_by_date
    assert_equal [1], @sa.find_invoice_items_by_invoice_date(
      Time.parse('2012-10-07')
    )
  end

  def test_total_revenue_by_date
    assert_equal 681.75, @sa.total_revenue_by_date(
      Time.parse('2012-10-07')
    ).to_f
  end

  def test_merchants_with_only_one_item
    assert_equal 0, @sa.merchants_with_only_one_item.length
  end

  def test_merchants_with_pending_invoices
    assert_equal 1, @sa.merchants_with_pending_invoices.length
  end

  def test_merchants_by_revenue
    expected = @sa.merchants_by_revenue
    assert_equal Hash, expected.class
    assert_equal 2780.91, expected[1].to_f
    assert_equal 8395.52, expected[2].to_f
  end

  def test_sort_merchants_by_revenue
    expected = @sa.sort_merchants_by_revenue
    assert_equal 74.36, expected[4]
    assert_equal 2780.91, expected[1]
  end

  def test_top_revenue_earners
    expected = @sa.top_revenue_earners
    assert_equal Merchant, expected.first.class
    assert_equal 4, expected.length
    assert_equal 3, expected.first.id
  end

  def test_merchants_ranked_by_revenue
    expected = @sa.merchants_ranked_by_revenue
    assert_equal 4, expected.length
    assert_equal 3, expected[0].id
    assert_equal 4, expected[3].id
  end

  def test_revenue_by_merchant
    expected = @sa.revenue_by_merchant(1)
    assert_equal 2780.91, expected.to_f
  end

  def test_merchants_with_only_one_item_registered_in_month
    expected = @sa.merchants_with_only_one_item_registered_in_month('December')
    assert_equal 0, expected.length
    assert_equal Array, expected.class
  end

  def test_find_paid_invoices_per_merchant
    expected = @sa.find_paid_invoices_per_merchant(1)
    assert_equal 2, expected.length
    assert_equal Invoice, expected.first.class
  end

  def test_find_invoices_by_invoice_id
    invoice_per_merchant = @sa.find_paid_invoices_per_merchant(1)
    expected = @sa.find_invoices_by_invoice_id(invoice_per_merchant)
    assert_equal Array, expected.class
    assert_equal InvoiceItem, expected.first.class
  end

  def test_find_item_quantities_sold_by_merchant
    invoice_per_merchant = @sa.find_paid_invoices_per_merchant(1)
    invoice_id = @sa.find_invoices_by_invoice_id(invoice_per_merchant)
    expected = @sa.find_item_quantities_sold_by_merchant(invoice_id)
    assert_equal Hash, expected.class
    assert_equal 9, expected[2]
  end

  def test_most_sold_item_for_merchant
    expected = @sa.most_sold_item_for_merchant(1)
    assert_equal 2, expected[0].id
  end

  def test_find_item_revenue_sold_by_merchant
    invoice_per_merchant = @sa.find_paid_invoices_per_merchant(1)
    invoice_id = @sa.find_invoices_by_invoice_id(invoice_per_merchant)
    expected = @sa.find_item_revenue_sold_by_merchant(invoice_id)
    assert_equal 681.75, expected[1]
  end

  def test_calculate_highest_revenue_item_by_merchant
    items = { '1': 681.75, '2': 987.60 }
    expected = @sa.calculate_highest_revenue_item_by_merchant(items)
    assert_equal 987.60, expected[1]
    assert_equal 2, expected.length
  end

  def test_best_item_for_merchant
    expected = @sa.best_item_for_merchant(1)
    assert_equal Item, expected.class
    assert_equal 2, expected.id
  end
end
