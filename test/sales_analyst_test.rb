require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'

require 'pry'

class SalesAnalystTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants_test.csv",
            :items => "./data/items_test.csv",
            :invoices => "./data/invoices_test.csv",
            :invoice_items => "./data/invoice_items_test.csv", :transactions => "./data/transactions_test.csv"}
    @sales_engine = SalesEngine.from_csv(data)
    @sa = @sales_engine.analyst
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

  def test_it_gets_invoices
    assert_equal 10, @sa.invoices.length
  end

  def test_it_gets_invoice_items
    assert_equal 10, @sa.invoice_items.length
  end

  def test_it_groups_items_by_merchant
    assert_equal 4, @sa.items_by_merchant.length
  end

  def test_average_items_per_merchant
    assert_equal 2.5, @sa.average_items_per_merchant
    assert_equal Float, @sa.average_items_per_merchant.class
  end

  def test_list_of_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@sa.items_by_merchant, mean)
    assert_equal Array, deviations.class
    assert_equal 4, deviations.length
    assert_equal -0.5, deviations[0]
  end

  def test_square_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@sa.items_by_merchant, mean)
    square_deviations = @sa.square_deviations(deviations)
    assert_equal Array, square_deviations.class
    assert_equal 4, square_deviations.length
    assert_equal 0.25,  square_deviations[0]
  end

  def test_sum_of_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@sa.items_by_merchant, mean)
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

  def test_get_list_of_high_item_count_merchant_ids
    assert_equal Array, @sa.high_item_count_list.class
    assert_equal 4, @sa.high_item_count_list.length
  end

  def test_merchants_with_high_item_count
    assert_equal 4, @sa.merchants_with_high_item_count.length
    assert_equal Merchant, @sa.merchants.first.class
  end

  def test_calculate_average_price
    merchant_id = 1
    expected = @sa.calculate_average_price(merchant_id)
    assert_equal 10.0, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_average_item_price_for_merchant
    merchant_id = 3
    expected = @sa.average_item_price_for_merchant(merchant_id)
    assert_equal 18.33, expected
    assert_equal BigDecimal, expected.class
  end

  def test_average_average_price_per_merchant
    skip
    expected = @sa.average_average_price_per_merchant
    assert_equal 18.0, expected
    assert_equal BigDecimal, expected.class
  end

  def test_calculate_mean_for_items
    expected = @sa.calculate_mean(@sa.items)
    assert_equal 16.0, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_deviation_list_for_items
    mean = @sa.calculate_mean(@sa.items)
    expected = @sa.deviation_list_for_items(mean)
    assert_equal 10, expected.length
    assert_equal Array, expected.class
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

  def test_high_invoice_count_merchants
    expected = @sa.high_invoice_count_merchants
    assert_equal 0, expected.length
  end

  def test_top_merchants_by_invoice_count
    expected = @sa.top_merchants_by_invoice_count
    assert_equal 0, expected.length
    assert_equal Array, expected.class
  end

  def test_low_invoice_count_merchants
    expected = @sa.low_invoice_count_merchants
    assert_equal 0, expected.length
  end

  def test_bottom_merchants_by_invoice_count
    expected = @sa.bottom_merchants_by_invoice_count
    assert_equal 0, expected.length
  end

  def test_invoices_created_by_day
    expected = @sa.invoices_created_by_day
    assert_equal Array, expected.class
    assert_equal 10, expected.length
  end

  def test_count_invoices_created_by_day
    expected = @sa.count_invoices_created_by_day
    assert_equal Hash, expected.class
    assert_equal 4, expected.length
  end

  def test_top_days_by_invoice_count
    expected = @sa.top_days_by_invoice_count
    assert_equal 1, expected.length
    assert_equal "Friday", expected.first
  end

  def test_invoice_status
    skip
    expected = @sa.invoice_status(:pending)
    assert_equal 45.0, expected
    expected = @sa.invoice_status(:shipped)
    assert_equal 50.0, expected
    expected = @sa.invoice_status(:returned)
    assert_equal 5.0, expected
  end

  def test_group_transactions_by_invoice
    assert_equal 10, @sa.transactions_by_invoice.length
  end

  def test_group_invoice_items_by_invoice_id
    assert_equal 10,
    @sa.invoice_items_by_invoice_id.length
  end

  def test_invoice_paid_in_full
    assert @sa.invoice_paid_in_full?(1)
  end

  def test_invoice_total
    skip
    assert_equal 21067.77, @sa.invoice_total(1)
  end

  def test_group_invoices_by_date
    skip
    assert_equal 10, @sa.group_invoices_by_date.length
    assert_equal Array, @sa.group_invoices_by_date[Time.parse("2010-12-07")].class
  end

  def test_find_invoice_ids_by_date
    skip
    assert_equal [1], @sa.find_invoice_items_by_invoice_date(Time.parse("2009-02-07"))
  end

  def test_total_revenue_by_date
    skip
    assert_equal 21067.77, @sa.total_revenue_by_date(Time.parse("2009-02-07"))
  end

  def test_merchants_with_only_one_item
    assert_equal 0, @sa.merchants_with_only_one_item.length
  end

  def test_merchants_with_pending_invoices
    assert_equal 1, @sa.merchants_with_pending_invoices.length
  end

  def test_convert_month_to_number
    assert_equal 3, @sa.convert_month_to_number("March")
  end

  def test_merchants_by_revenue
    expected = @sa.merchants_by_revenue
    assert_equal Hash, expected.class
    assert_equal 2780.91, expected[1].to_f
    assert_equal 8395.52, expected[2].to_f
    assert_equal 9891.34, expected[3].to_f
    assert_equal 74.36, expected[4].to_f
  end

  def test_sort_merchants_by_revenue
    expected = @sa.sort_merchants_by_revenue
    assert_equal 74.36, expected[4]
    assert_equal 2780.91, expected[1]
    assert_equal 8395.52, expected[2]
    assert_equal 9891.34, expected[3]
  end

  def test_top_revenue_earners
    expected = @sa.top_revenue_earners
    assert_equal Merchant, expected.first.class
    assert_equal 4, expected.length
    assert_equal 3, expected.first.id
    expected = @sa.top_revenue_earners(2)
    assert_equal Merchant, expected.first.class
    assert_equal 2, expected.length
    assert_equal 3, expected.first.id
  end

  def test_merchants_ranked_by_revenue
    skip
    expected = @sa.merchants_ranked_by_revenue
    assert_equal 4, expected.length
    assert_equal 3, expected[0].id
    assert_equal 4, expected[4].id
  end

  def test_revenue_by_merchant
    expected = @sa.revenue_by_merchant(1)
    assert_equal 2780.91, expected.to_f
  end

  def test_merchants_with_only_one_item_registered_in_month
    skip
    expected = @sa.merchants_with_only_one_item_registered_in_month("December")
    assert_equal 0, expected.length
    assert_equal Array, expected.class
    assert_equal Merchant, expected.first.class
  end

  def test_calculate_quantity_sold_from_item_id
    expected = @sa.calculate_quantity_sold_from_item_id(1)
    item_and_quantity = {1 => 5}
    assert_equal item_and_quantity, expected
  end

  def test_items_sold_by_merchant_by_quantity
    expected = @sa.items_sold_by_merchant_by_quantity(1)
    assert_equal Hash, expected.class
    assert_equal 5, expected[1]
    assert_equal 2, expected.length
  end

  def test_find_highest_values_of_items_sold_by_merchant
    expected = @sa.find_highest_values_of_items_sold_by_merchant(@sa.items_sold_by_merchant_by_quantity(1))
    assert_equal Item, expected.first.class
    assert_equal 1, expected.length
    assert_equal 2, expected.first.id
  end

  def test_calculate_total_amount_of_revenue_from_item
    expected = @sa.calculate_total_amount_of_revenue_from_item(1)
    assert_equal Hash, expected.class
    assert_equal 681.75, expected[1]
    assert_equal 1, expected.length
  end

  def test_best_item_for_merchant
    expected = @sa.find_highest_values_of_items_sold_by_merchant(@sa.calculate_total_amount_of_revenue_from_item(1))
    assert_equal Item, expected.first.class
    assert_equal 1, expected.length
    assert_equal 1, expected.first.id
  end
end
